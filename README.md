# Installing OpenShift in Disconnected AWS GovCloud using IPI + Software Factory


## Overview

This guide is intended to demonstrate how to perform the OpenShift installation using the IPI method on AWS GovCloud. In addition, the guide will walk through performing this installation on a fresh GovCloud account. If you already have a VPC setup and subnets, please skip to Installing Openshift. Additionally this demostrates the install of Operator Catalog with addition to the Red Hat Gov Operator Catalog

## AWS Configuration Requirements for Demo
   
For this demo, that AWS API communication is facilitated by a squid proxy. Without that access, we will not be able to install a cloud aware OpenShift cluster. 

A Cloud Formation template that details the VPC with squid proxy used in this demo can be found [**here**](https://github.com/dmc5179/openshift4-disconnected/blob/master/cloudformation/disconnected_vpc/disconnected_vpc.yaml). This will be needed to install Openshift, bundle the images, and create the AMI. The following ports will need to be open to communicate with the OCP nodes and AWS API once the EC2 is running.

| Ports     | IPs |
| ----------- | ----------- |
| 5000        | 0.0.0.0/0   |
| 443         | 108.175.0.0/16 |
| 443         | 96.127.0.0/16 | 
| 443         | 52.46.0.0/16 |


This guide will assume that the user has valid accounts and subscriptions to both Red Hat OpenShift and AWS GovCloud. In this demo we are using Cluster Admin credentials in AWS, but can use the VM Import/Export role + EC2 LB + Route 53 (if using for DNS).  
#
## Installing OpenShift 

### Dependencies

You will need to install podman to pull the images, skopeo to copy the additional images, and jq for your pull secret.

```sudo yum install podman skopeo jq -y```


### Create OpenShift Installation Bundle
1. Use AWS Session Manager to connect to the EC2 squid proxy that seconds as the bootstramp. Download and compress the bundle on internet connected machine using the OpenShift4-mirror companion utility found [**here**](https://repo1.dso.mil/platform-one/distros/red-hat/ocp4/openshift4-mirror)
   

   You will first need to retrieve an OpenShift pull secret. Once you have retrieved that, enter it into the literals of the value for `--pull-secret` in the command below. Pull secrets can be obtained from https://cloud.redhat.com/openshift/install/aws/installer-provisioned

     ```bash
    OCP_VER=$(curl http://mirror.openshift.com/pub/openshift-v4/clients/ocp/stable/release.txt 2>&1 | grep -oP "(?<=Version:\s\s).*")
    podman run -it --security-opt label=disable -v ./:/app/bundle quay.io/redhatgov/openshift4_mirror:latest \
      ./openshift_mirror bundle \
      --openshift-version ${OCP_VER} \
      --platform aws \
      --skip-existing \
      --skip-catalogs \
      --pull-secret ${PULL_SECRET} && \
    git clone https://github.com/redhat-cop/ocp-disconnected-docs.git ./${OCP_VER}/ocp-disconnected && \
    tar -zcvf openshift-${OCP_VER}.tar.gz ${OCP_VER}
    ```
2. Transfer bundle from internet connected machine to disconnected vpc host.

#
### Prepare and Deploy
3. Extract bundle on disconnected vpc host. From the directory containing the OCP bundle.
    ```bash
    OCP_VER=$(ls | grep -oP '(?<=openshift-)\d\.\d\.\d(?=.tar.gz)')    
    tar -xzvf openshift-${OCP_VER}.tar.gz
    ```

4. Create S3 Bucket and attach policies.

    ```bash
    export awsreg=$(aws configure get region)
    export s3name=$(date +%s"-rhcos")
    aws s3api create-bucket --bucket ${s3name} --region ${awsreg} --create-bucket-configuration LocationConstraint=${awsreg}
    aws iam create-role --role-name vmimport --assume-role-policy-document "file://${OCP_VER}/ocp-disconnected/aws-gov-ipi-dis-maniam/trust-policy.json"
    envsubst < ./${OCP_VER}/ocp-disconnected/aws-gov-ipi-dis-maniam/role-policy-templ.json > ./${OCP_VER}/ocp-disconnected/aws-gov-ipi-dis-maniam/role-policy.json
    aws iam put-role-policy --role-name vmimport --policy-name vmimport --policy-document "file://${OCP_VER}/ocp-disconnected/aws-gov-ipi-dis-maniam/role-policy.json"
    ```

5. Upload RHCOS Image to S3

    ```bash
    export RHCOS_VER=$(ls ./${OCP_VER}/rhcos/ | grep -oP '.*(?=\.vmdk.gz)')
    gzip -d ./${OCP_VER}/rhcos/${RHCOS_VER}.vmdk.gz
    aws s3 mv ./${OCP_VER}/rhcos/${RHCOS_VER}.vmdk s3://${s3name}
    ```

6. Create AMI

    ```bash
    envsubst < ./${OCP_VER}/ocp-disconnected/aws-gov-ipi-dis-maniam/containers-templ.json > ./${OCP_VER}/ocp-disconnected/containers.json
    taskid=$(aws ec2 import-snapshot --region ${awsreg} --description "rhcos-snapshot" --disk-container file://${OCP_VER}/ocp-disconnected/containers.json | jq -r '.ImportTaskId')
    until [[ $resp == "completed" ]]; do sleep 2; echo "Snapshot progress: "$(aws ec2 describe-import-snapshot-tasks --region ${awsreg} | jq --arg task "$taskid" -r '.ImportSnapshotTasks[] | select(.ImportTaskId==$task) | .SnapshotTaskDetail.Progress')"%"; resp=$(aws ec2 describe-import-snapshot-tasks --region ${awsreg} | jq --arg task "$taskid" -r '.ImportSnapshotTasks[] | select(.ImportTaskId==$task) | .SnapshotTaskDetail.Status'); done
    snapid=$(aws ec2 describe-import-snapshot-tasks --region ${awsreg} | jq --arg task "$taskid" '.ImportSnapshotTasks[] | select(.ImportTaskId==$task) | .SnapshotTaskDetail.SnapshotId')
    aws ec2 register-image \
      --region ${awsreg} \
      --architecture x86_64 \
      --description "${RHCOS_VER}" \
      --ena-support \
      --name "${RHCOS_VER}" \
      --virtualization-type hvm \
      --root-device-name '/dev/xvda' \
      --block-device-mappings 'DeviceName=/dev/xvda,Ebs={DeleteOnTermination=true,SnapshotId='${snapid}'}' 
    ```

7. Record the AMI ID from the output of the above command.

8. Create registry cert on disconnected vpc host
    ```bash
    export SUBJ="/C=US/ST=Virginia/O=Red Hat/CN=${HOSTNAME}"
    openssl req -newkey rsa:4096 -nodes -sha256 -keyout registry.key -x509 -days 365 -out registry.crt -subj "$SUBJ" -addext "subjectAltName = DNS:$HOSTNAME"
    ```    

9. Make a copy of the install config
    ```bash
    mkdir ./${OCP_VER}/config
    cp ./${OCP_VER}/ocp-disconnected/aws-gov-ipi-dis-maniam/install-config-template.yaml ./${OCP_VER}/config/install-config.yaml
    ```
10. Edit install config
    For this step, Open `./${OCP_VER}/config/install-config.yaml` and edit the following fields:

    ```yaml
    baseDomain: i.e. example.com
    additionalTrustBundle: copy and paste the content of ./registry.crt here.
    imageContentSources:
      mirrors: Only edit the registry hostname fields of this section. Make sure that you use the $HOSTNAME of the devices that you are currently using.
    metadata:
      name: i.e. test-cluster
    networking:
      machineNetwork:
      - cidr: i.e. 10.0.41.0/20. Shorten or lengthen this list as needed.
    platform:
      aws:
        region: the default region of your configured aws cli 
        zones: A list of availability zones that you are deploying into. Shorten or lengthen this list as needed.
        subnets: i.e. subnet-ef12d288. The length of this list must match the .networking.machineNetwork[].cidr length.
        amiID: the AMI ID recorded from step 9
        pullSecret: your pull secret enclosed in literals
        sshKey: i.e ssh-rsa AAAAB3... No quotes
    ```
    Don't forget to save and close the file!

11. Make a backup of the final config:
    ```bash
    cp -R ./${OCP_VER}/config/ ./${OCP_VER}/config.bak
    ```

12. Create manifests from install config.
    ```bash
    openshift-install create manifests --dir ./${OCP_VER}/config
    ```

13. create iam users and Policies

    ```bash
    cd ./${OCP_VER}/ocp-disconnected/aws-gov-ipi-dis-maniam
    chmod +x ./ocp-users.sh
    ./ocp-users.sh prepPolicies
    ./ocp-users.sh createUsers
    ```

14. Use the convenience script to create the aws credentials and kubernetes secrets:
    ```bash
    chmod +x ./secret-helper.sh
    ./secret-helper.sh
    cp secrets/* ../../config/openshift/
    cd -
    ```

15. start up the registry in the background
    ```bash
    oc image serve --dir=./${OCP_VER}/release/ --tls-crt=./registry.crt --tls-key=./registry.key &
    ```

16. Deploy the cluster

    ```
    openshift-install create cluster --dir ./${OCP_VER}/config
    ```
#
### Cluster Access

You can now access the cluster via CLI with oc or the web console with a web browser.

1. Locate the OpenShift access information provided by the final installer output.

    Example:
    ```
    INFO Waiting up to 10m0s for the openshift-console route to be created... 
    INFO Install complete!                            
    INFO To access the cluster as the system:admin user when using 'oc', run 'export KUBECONFIG=/home/ec2-user/data/vid-pres/${OCP_VER}/config/auth/kubeconfig' 
    INFO Access the OpenShift web-console here: https://console-openshift-console.apps.test-cluster.testocp1.net 
    INFO Login to the console with user: "kubeadmin", and password: "z9yDP-2M6DS-oE9Im-Dcdzk" 
    INFO Time elapsed: 48m34s    
    ```

2. Set the default kube context used by oc and kubectl:  

    Example:
    ```
    export KUBECONFIG=/home/ec2-user/data/vid-pres/4.7.0/config/auth/kubeconfig
    ```

    _Config file optionaly availible at `$OCP_VER/config/auth`_

3. Access the web console:

    URL Example:
    `https://console-openshift-console.apps.test-cluster.testocp1.net`

    Credentials Example:  
    ```
    INFO Login to the console with user: "kubeadmin", and password: "z9yDP-2M6DS-oE9Im-Dcdzk
    ```
#
### Adding Operators into Openshift

21. Create a RHEL 7.9 EC2 from the AWS console within your public subnet to be our local container registry 

22. Please SSH into EC2 and register RHEL instance will subscription manager
      ``` 
      sudo subscription-manager register --auto-attach 
      ```
23. Install Podman & Skopeo & JQ
      ```
      sudo yum install -y podman httpd-tools skopeo jq git
      ```
24. Create folders for the registry
      ```
      sudo mkdir -p /var/lib/registry
      ```
25. Deploy local podman registry
      ```
      sudo podman run --privileged -d --name registry -p 5000:5000 -v /var/lib/registry:/var/lib/registry --restart=always registry:2
      ```
26. Allow traffic from firewall
      ```
      sudo firewall-cmd --add-port=5000/tcp --zone=internal --permanent
      sudo firewall-cmd --add-port=5000/tcp --zone=public --permanent
      sudo firewall-cmd --reload
      ```
27. Add Red Hat pull secret to Podman creditials file
      Copy pull secret from cloud.redhat.com and place it in the EC2 as pull.yaml
      ```
      sudo jq . pull.yaml >> /root/.docker/config.json
      ```
28. Clone Repo & Start the images transfer (this will take a while!)
      ```
      git clone https://github.com/afouladi7/disconnected_software_factory.git
      sudo ./disconnected_images_transfer.sh
      ```
29. Update the machineconfig on Openshift to use the new local mirror
      Login to OC via the token, located in the top right of the OCP console.
      ```
      ./local_reg.sh
      ./machine_config.sh
      ```
30. Wait till the master and workers have been updated. If you do see some pods still in a failing or image pull back state. Delete them and they should pull from the correct location.
       
31. Create a `CatalogSource` to import the RedHatGov operator catalog.
```
  oc apply -f - << EOF
  apiVersion: operators.coreos.com/v1alpha1
  kind: CatalogSource
  metadata:
    name: redhatgov-operators
    namespace: openshift-marketplace
  spec:
    sourceType: grpc
    image: quay.io/redhatgov/operator-catalog:latest
    displayName: Red Hat NAPS Community Operators
    publisher: RedHatGov
  EOF      
```

32. Create a project for your pipeline tooling to live.

  `oc new-project devsecops`

33. Ploigos is hungry - delete any `LimitRange` that might have been created from project templates:

  ```oc delete limitrange --all -n devsecops```
  
34. Install Ploigos Operator  
