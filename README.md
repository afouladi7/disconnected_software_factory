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

    ```
    podman run -it --security-opt label=disable -v ./:/app/bundle quay.io/redhatgov/openshift4_mirror:latest \
      ./openshift_mirror bundle \
      --openshift-version 4.7.0 \
      --platform aws \
      --skip-existing \
      --skip-catalogs \
      --pull-secret '{"auths":{"cloud.openshift.com":{"auth":"b3Blb...' && \
    git clone https://repo1.dso.mil/platform-one/distros/red-hat/ocp4/documentation.git ./4.7.0/ocp-disconnected && \
    tar -zcvf openshift-4-7-0.tar.gz 4.7.0
    ```
2. Transfer bundle from internet connected machine to disconnected vpc host.

#
### Prepare and Deploy
3. Extract bundle on disconnected vpc host.
    ```    
    tar -xzvf openshift-4-7-0.tar.gz
    ```

4. Create S3 Bucket and attach policies.

    ```
    export awsreg=$(aws configure get region)
    export s3name=$(date +%s"-rhcos")
    aws s3api create-bucket --bucket ${s3name} --region ${awsreg} --create-bucket-configuration LocationConstraint=${awsreg}
    aws iam create-role --role-name vmimport --assume-role-policy-document "file://4.7.0/ocp-disconnected/aws-gov-ipi-dis-maniam/trust-policy.json"
    envsubst < ./4.7.0/ocp-disconnected/aws-gov-ipi-dis-maniam/role-policy-templ.json > ./4.7.0/ocp-disconnected/aws-gov-ipi-dis-maniam/role-policy.json
    aws iam put-role-policy --role-name vmimport --policy-name vmimport --policy-document "file://4.7.0/ocp-disconnected/aws-gov-ipi-dis-maniam/role-policy.json"
    ```

5. Upload RHCOS Image to S3

    ```
    gzip -d ./4.7.0/rhcos/rhcos-47.83.202102090044-0-aws.x86_64.vmdk.gz
    aws s3 mv ./4.7.0/rhcos/rhcos-47.83.202102090044-0-aws.x86_64.vmdk s3://${s3name}
    ```

6. Create AMI

    ```
    envsubst < ./4.7.0/ocp-disconnected/aws-gov-ipi-dis-maniam/containers-templ.json > ./4.7.0/ocp-disconnected/containers.json
    taskid=$(aws ec2 import-snapshot --region ${awsreg} --description "rhcos-snapshot" --disk-container file://4.7.0/ocp-disconnected/containers.json | jq -r '.ImportTaskId')
    until [[ $resp == "completed" ]]; do sleep 2; echo "Snapshot progress: "$(aws ec2 describe-import-snapshot-tasks --region ${awsreg} | jq --arg task "$taskid" -r '.ImportSnapshotTasks[] | select(.ImportTaskId==$task) | .SnapshotTaskDetail.Progress')"%"; resp=$(aws ec2 describe-import-snapshot-tasks --region ${awsreg} | jq --arg task "$taskid" -r '.ImportSnapshotTasks[] | select(.ImportTaskId==$task) | .SnapshotTaskDetail.Status'); done
    snapid=$(aws ec2 describe-import-snapshot-tasks --region ${awsreg} | jq --arg task "$taskid" '.ImportSnapshotTasks[] | select(.ImportTaskId==$task) | .SnapshotTaskDetail.SnapshotId')
    aws ec2 register-image \
      --region ${awsreg} \
      --architecture x86_64 \
      --description "rhcos-47.83.202102090044-0-aws.x86_64" \
      --ena-support \
      --name "rhcos-47.83.202102090044-0-aws.x86_64" \
      --virtualization-type hvm \
      --root-device-name '/dev/xvda' \
      --block-device-mappings 'DeviceName=/dev/xvda,Ebs={DeleteOnTermination=true,SnapshotId='${snapid}'}' 
    ```

7. Record the AMI ID from the output of the above command.

8. Create registry cert on disconnected vpc host
    ```
    export SUBJ="/C=US/ST=Virginia/O=Red Hat/CN=${HOSTNAME}"
    openssl req -newkey rsa:4096 -nodes -sha256 -keyout registry.key -x509 -days 365 -out registry.crt -subj "$SUBJ"
    ```    

9. Make a copy of the install config
    ```
    mkdir ./4.7.0/config
    cp ./4.7.0/ocp-disconnected/aws-gov-ipi-dis-maniam/install-config-template.yaml ./4.7.0/config/install-config.yaml
    ```
10. Edit install config
    For this step, Open `./4.7.0/config/install-config.yaml` and edit the following fields:

    ```
    baseDomain: i.e. example.com
    additionalTrustBundle: copy and paste the content of ./registry.crt here.
    imageContentSources:
      mirrors: Only edit the registry hostname fields of this section. Make sure that you use the $HOSTNAME of the devices that you are currently using.
    metadata:
      name: i.e. test-cluster
    networking:
      machineNetwork:
      - cidr: i.e. 10.0.41.0/20. Shorten or lengthen this list as needed. You will need 3 of these.
    platform:
      aws:
        region: the default region of your configured aws cli 
        zones: A list of availability zones that you are deploying into. Shorten or lengthen this list as needed.
        subnets: i.e. subnet-ef12d288. Please add all 3 subnets in AZ. The length of this list must match the .networking.machineNetwork[].cidr length.
        amiID: the AMI ID recorded from step 9
        pullSecret: your pull secret enclosed in literals
        sshKey: i.e ssh-rsa AAAAB3... No quotes
    ```
    Don't forget to save and close the file!

11. Make a backup of the final config:
    ```
    cp -R ./4.7.0/config/ ./4.7.0/config.bak
    ```

12. Create manifests from install config.
    ```
    openshift-install create manifests --dir ./4.7.0/config
    ```

13. Delete the installer generated secret
    ```
    rm ./4.7.0/config/openshift/99_cloud-creds-secret.yaml 
    ```
14. create iam users and Policies

    ```
    cd ./4.7.0/ocp-disconnected/aws-gov-ipi-dis-maniam
    chmod +x ./ocp-users.sh
    ./ocp-users.sh prepPolicies
    ./ocp-users.sh createUsers
    ```

15. Use the convenience script to create the aws credentials and kubernetes secrets:
    ```
    chmod +x ./secret-helper.sh
    ./secret-helper.sh
    cp secrets/* ../../config/openshift/
    cd -
    ```

16. start up the registry in the background
    ```
    oc image serve --dir=./4.7.0/release/ --tls-crt=./registry.crt --tls-key=./registry.key &
    ```

17. Deploy the cluster

    ```
    openshift-install create cluster --dir ./4.7.0/config
    ```
#
### Cluster Access

You can now access the cluster via CLI with oc or the web console with a web browser.

18. Locate the OpenShift access information provided by the final installer output.

    Example:
    ```
    INFO Waiting up to 10m0s for the openshift-console route to be created... 
    INFO Install complete!                            
    INFO To access the cluster as the system:admin user when using 'oc', run 'export KUBECONFIG=/home/ec2-user/data/vid-pres/4.7.0/config/auth/kubeconfig' 
    INFO Access the OpenShift web-console here: https://console-openshift-console.apps.test-cluster.testocp1.net 
    INFO Login to the console with user: "kubeadmin", and password: "z9yDP-2M6DS-oE9Im-Dcdzk" 
    INFO Time elapsed: 48m34s    
    ```

19. Set the default kube context used by oc and kubectl:  

    Example:
    ```
    export KUBECONFIG=/home/ec2-user/data/vid-pres/4.7.0/config/auth/kubeconfig
    ```
20. Access the web console:

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
      sudo yum install -y podman httpd-tools skopeo jq
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
28. Start the images transfer (this will take a while!)
      ```
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
