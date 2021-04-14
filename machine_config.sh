#!/bin/bash -xe

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

# Source the environment file with the default settings
#source "${SCRIPT_DIR}/../env.sh"

# Read in the new chrony.conf file
ICSP_B64=$(cat ./mirror.conf | sed "s|registry.example.com|${REMOTE_REG}|g" | sed "s|LOCAL_REPO|${LOCAL_REPO}|g" | base64 -w 0)

# Create a machine config to set the private registry for master nodes
rm -f ./99_master-private-registry-configuration.yaml
cat << EOF > ./99_master-private-registry-configuration.yaml
apiVersion: machineconfiguration.openshift.io/v1
kind: MachineConfig
metadata:
  labels:
    machineconfiguration.openshift.io/role: master
  name: 99-zmaster-priv-reg-configuration
spec:
  config:
    ignition:
      config: {}
      security:
        tls: {}
      timeouts: {}
      version: 2.2.0
    networkd: {}
    passwd: {}
    storage:
      files:
      - contents:
          source: data:text/plain;charset=utf-8;base64,${ICSP_B64}
          verification: {}
        filesystem: root
        mode: 420
        path: /etc/containers/registries.conf
  osImageURL: ""
EOF

# Create a machine config to set the private registry ICSP for worker nodes
rm -f ./99_worker-private-registry-configuration.yaml
cat << EOF > ./99_worker-private-registry-configuration.yaml
apiVersion: machineconfiguration.openshift.io/v1
kind: MachineConfig
metadata:
  labels:
    machineconfiguration.openshift.io/role: worker
  name: 99-zworker-priv-reg-configuration
spec:
  config:
    ignition:
      config: {}
      security:
        tls: {}
      timeouts: {}
      version: 2.2.0
    networkd: {}
    passwd: {}
    storage:
      files:
      - contents:
          source: data:text/plain;charset=utf-8;base64,${ICSP_B64}
          verification: {}
        filesystem: root
        mode: 420
        path: /etc/containers/registries.conf
  osImageURL: ""
EOF

oc apply -f ./99_master-private-registry-configuration.yaml
oc apply -f ./99_worker-private-registry-configuration.yaml

exit 0

