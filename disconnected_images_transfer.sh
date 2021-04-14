#!/bin/bash

read -p "Please enter the IP of your Docker Container Registry: " ip

declare skopeo_copy="skopeo copy --all --dest-tls-verify=false"
declare internal_reg="docker://${ip}:5000"
declare tssc_tag="latest"

${skopeo_copy} \
  docker://quay.io/redhatgov/operator-catalog:1.5.10 \
  ${internal_reg}/redhatgov/operator-catalog:1.5.10
${skopeo_copy} \
  docker://quay.io/redhatgov/operator-catalog:1.5.10 \
  ${internal_reg}/redhatgov/operator-catalog:${tssc_tag}

${skopeo_copy} \
  docker://quay.io/redhatgov/tssc-operator-bundle:0.2.3 \
  ${internal_reg}/redhatgov/tssc-operator-bundle:0.2.3
${skopeo_copy} \
  docker://quay.io/redhatgov/tssc-operator-bundle:0.2.3 \
  ${internal_reg}/redhatgov/tssc-operator-bundle:${tssc_tag}
${skopeo_copy} \
  docker://quay.io/snelson/tssc-operator:${tssc_tag} \
  ${internal_reg}/redhatgov/tssc-operator:0.2.3
${skopeo_copy} \
  docker://quay.io/snelson/tssc-operator:${tssc_tag} \
  ${internal_reg}/redhatgov/tssc-operator:${tssc_tag}

${skopeo_copy} \
  docker://quay.io/redhatgov/devsecops-operator:${tssc_tag} \
  ${internal_reg}/redhatgov/devsecops-operator:${tssc_tag}
${skopeo_copy} \
  docker://quay.io/redhatgov/devsecops-operator-bundle:${tssc_tag} \
  ${internal_reg}/redhatgov/devsecops-operator-bundle:${tssc_tag}

${skopeo_copy} \
  docker://quay.io/redhatgov/gitea-operator:0.0.5 \
  ${internal_reg}/redhatgov/gitea-operator:${tssc_tag}
${skopeo_copy} \
  docker://quay.io/redhatgov/gitea-operator-bundle:0.0.5 \
  ${internal_reg}/redhatgov/gitea-operator-bundle:${tssc_tag}

${skopeo_copy} \
  docker://quay.io/redhatgov/mattermost-operator:v1.0.0 \
  ${internal_reg}/redhatgov/mattermost-operator:v1.0.0
${skopeo_copy} \
  docker://quay.io/redhatgov/mattermost-operator-bundle:1.0.0 \
  ${internal_reg}/redhatgov/mattermost-operator-bundle:1.0.0

${skopeo_copy} \
  docker://quay.io/redhatgov/nexus-operator:0.0.9 \
  ${internal_reg}/redhatgov/nexus-operator:0.0.9
${skopeo_copy} \
  docker://quay.io/redhatgov/nexus-operator:0.0.9 \
  ${internal_reg}/redhatgov/nexus-operator:${tssc_tag}
${skopeo_copy} \
  docker://quay.io/redhatgov/nexus-operator-bundle:0.0.9 \
  ${internal_reg}/redhatgov/nexus-operator-bundle:0.0.9
${skopeo_copy} \
  docker://quay.io/redhatgov/nexus-operator-bundle:0.0.9 \
  ${internal_reg}/redhatgov/nexus-operator-bundle:${tssc_tag}

${skopeo_copy} \
  docker://quay.io/redhatgov/selenium-grid-operator:0.0.1 \
  ${internal_reg}/redhatgov/selenium-grid-operator:0.0.1
${skopeo_copy} \
  docker://quay.io/redhatgov/selenium-grid-operator-bundle:0.0.1 \
  ${internal_reg}/redhatgov/selenium-grid-operator-bundle:0.0.1
${skopeo_copy} \
  docker://quay.io/redhatgov/selenium-grid-operator:0.0.2 \
  ${internal_reg}/redhatgov/selenium-grid-operator:0.0.2
${skopeo_copy} \
  docker://quay.io/redhatgov/selenium-grid-operator-bundle:0.0.2 \
  ${internal_reg}/redhatgov/selenium-grid-operator-bundle:0.0.2

${skopeo_copy} \
  docker://quay.io/redhatgov/sonarqube-operator:0.0.3 \
  ${internal_reg}/redhatgov/sonarqube-operator:0.0.3
${skopeo_copy} \
  docker://quay.io/redhatgov/sonarqube-operator:0.0.3 \
  ${internal_reg}/redhatgov/sonarqube-operator:${tssc_tag}
${skopeo_copy} \
  docker://quay.io/redhatgov/sonarqube-operator-bundle:0.0.3 \
  ${internal_reg}/redhatgov/sonarqube-operator-bundle:0.0.3
${skopeo_copy} \
  docker://quay.io/redhatgov/sonarqube-operator-bundle:0.0.3 \
  ${internal_reg}/redhatgov/sonarqube-operator-bundle:${tssc_tag}

${skopeo_copy} \
  docker://quay.io/redhatgov/gitea:${tssc_tag} \
  ${internal_reg}/redhatgov/gitea:${tssc_tag}
${skopeo_copy} \
  docker://quay.io/redhatgov/sonarqube:${tssc_tag} \
  ${internal_reg}/redhatgov/sonarqube:${tssc_tag}

${skopeo_copy} \
  docker://docker.io/argoproj/argocd@sha256:b835999eb5cf75d01a2678cd971095926d9c2566c9ffe746d04b83a6a0a2849f \
  ${internal_reg}/argoproj/argocd@sha256:b835999eb5cf75d01a2678cd971095926d9c2566c9ffe746d04b83a6a0a2849f \
${skopeo_copy} \
  docker://docker.io/grafana/grafana@sha256:bdef6f27255a09deb2f89741b3800a9a394a7e9eefa032570760e5688dd00a2f \
  ${internal_reg}/grafana/grafana@sha256:bdef6f27255a09deb2f89741b3800a9a394a7e9eefa032570760e5688dd00a2f
${skopeo_copy} \
  docker://docker.io/library/redis@sha256:b33e5a3c00e5794324fad2fab650eadba0f65e625cc915e4e57995590502c269 \
  ${internal_reg}/library/redis@sha256:b33e5a3c00e5794324fad2fab650eadba0f65e625cc915e4e57995590502c269
${skopeo_copy} \
  docker://docker.io/mattermost/mattermost-team-edition \
  ${internal_reg}/mattermost/mattermost-team-edition
${skopeo_copy} \
  docker://docker.io/openshift/oauth-proxy:latest \
  ${internal_reg}/openshift/oauth-proxy:latest
${skopeo_copy} \
  docker://gcr.io/kubebuilder/kube-rbac-proxy:v0.5.0 \
  ${internal_reg}/kubebuilder/kube-rbac-proxy:v0.5.0
${skopeo_copy} \
  docker://quay.io/akrohg/ploigos-jenkins-sidecar:latest \
  ${internal_reg}/akrohg/ploigos-jenkins-sidecar:latest
${skopeo_copy} \
  docker://quay.io/openshift-release-dev/ocp-v4.0-art-dev@sha256:3c7086580e4d2b7abbb5fa7439c28896722609c8017bc11c8c051e2892e36ee1 \
  ${internal_reg}/openshift-release-dev/ocp-v4.0-art-dev@sha256:3c7086580e4d2b7abbb5fa7439c28896722609c8017bc11c8c051e2892e36ee1
${skopeo_copy} \
  docker://quay.io/openshift-release-dev/ocp-v4.0-art-dev@sha256:c61fbc4894e4a01684e7eb0bba41382a2dde95360aebfe44c827f21482822d6c \
  ${internal_reg}/openshift-release-dev/ocp-v4.0-art-dev@sha256:c61fbc4894e4a01684e7eb0bba41382a2dde95360aebfe44c827f21482822d6c
${skopeo_copy} \
  docker://quay.io/redhat-cop/argocd-operator@sha256:d661aba8a5bc7c8a69cd7d5da8193585118b93f3e7ef14a213e1fa9c2684b47c \
  ${internal_reg}/redhat-cop/argocd-operator@sha256:d661aba8a5bc7c8a69cd7d5da8193585118b93f3e7ef14a213e1fa9c2684b47c
${skopeo_copy} \
  docker://quay.io/redhat-cop/dex:v2.22.0-openshift \
  ${internal_reg}/redhat-cop/dex:v2.22.0-openshift
${skopeo_copy} \
  docker://quay.io/redhat/quay:v3.3.4 \
  ${internal_reg}/redhat/quay:v3.3.4
${skopeo_copy} \
  docker://quay.io/redhatgov/crw-devfile-registry-rhel8:2.3 \
  ${internal_reg}/redhatgov/crw-devfile-registry-rhel8:2.3
${skopeo_copy} \
  docker://quay.io/redhatgov/crw-plugin-registry-rhel8:2.3 \
  ${internal_reg}/redhatgov/crw-plugin-registry-rhel8:2.3
${skopeo_copy} \
  docker://quay.io/redhatgov/gitea-operator:latest \
  ${internal_reg}/redhatgov/gitea-operator:latest
${skopeo_copy} \
  docker://quay.io/redhatgov/gitea:latest \
  ${internal_reg}/redhatgov/gitea:latest
${skopeo_copy} \
  docker://quay.io/redhatgov/mattermost-operator:v1.0.0 \
  ${internal_reg}/redhatgov/mattermost-operator:v1.0.0
${skopeo_copy} \
  docker://quay.io/redhatgov/nexus-operator:latest \
  ${internal_reg}/redhatgov/nexus-operator:latest
${skopeo_copy} \
  docker://quay.io/redhatgov/selenium-grid-operator:0.0.1 \
  ${internal_reg}/redhatgov/selenium-grid-operator:0.0.1
${skopeo_copy} \
  docker://quay.io/redhatgov/selenium-hub:latest \
  ${internal_reg}/redhatgov/selenium-hub:latest
${skopeo_copy} \
  docker://quay.io/redhatgov/selenium-node-chrome:latest \
  ${internal_reg}/redhatgov/selenium-node-chrome:latest
${skopeo_copy} \
  docker://quay.io/redhatgov/selenium-node-firefox:latest \
  ${internal_reg}/redhatgov/selenium-node-firefox:latest
${skopeo_copy} \
  docker://quay.io/redhatgov/sonarqube-operator:latest \
  ${internal_reg}/redhatgov/sonarqube-operator:latest
${skopeo_copy} \
  docker://quay.io/redhatgov/sonarqube:latest \
  ${internal_reg}/redhatgov/sonarqube:latest
${skopeo_copy} \
  docker://quay.io/redhatgov/tssc-operator:latest \
  ${internal_reg}/redhatgov/tssc-operator:latest
${skopeo_copy} \
  docker://registry.access.redhat.com/ubi8/ubi-minimal \
  ${internal_reg}/ubi8/ubi-minimal
${skopeo_copy} \
  docker://registry.access.redhat.com/ubi8/ubi-minimal:latest \
  ${internal_reg}/ubi8/ubi-minimal:latest
${skopeo_copy} \
  docker://registry.connect.redhat.com/sonatype/nexus-repository-manager:latest \
  ${internal_reg}/sonatype/nexus-repository-manager:latest
${skopeo_copy} \
  docker://registry.redhat.io/argoproj/argocd@sha256:b835999eb5cf75d01a2678cd971095926d9c2566c9ffe746d04b83a6a0a2849f \
  ${internal_reg}/argoproj/argocd@sha256:b835999eb5cf75d01a2678cd971095926d9c2566c9ffe746d04b83a6a0a2849f
${skopeo_copy} \
  docker://registry.redhat.io/codeready-workspaces/crw-2-rhel8-operator@sha256:6d51d17ce2b3c5d638db6f0548f04057a2db9115aad1478ee5d8aeda8e599dbb \
  ${internal_reg}/codeready-workspaces/crw-2-rhel8-operator@sha256:6d51d17ce2b3c5d638db6f0548f04057a2db9115aad1478ee5d8aeda8e599dbb
${skopeo_copy} \
  docker://registry.redhat.io/codeready-workspaces/server-rhel8:2.3 \
  ${internal_reg}/codeready-workspaces/server-rhel8:2.3
${skopeo_copy} \
  docker://registry.redhat.io/grafana/grafana@sha256:bdef6f27255a09deb2f89741b3800a9a394a7e9eefa032570760e5688dd00a2f \
  ${internal_reg}/grafana/grafana@sha256:bdef6f27255a09deb2f89741b3800a9a394a7e9eefa032570760e5688dd00a2f
${skopeo_copy} \
  docker://registry.redhat.io/mattermost/mattermost-team-edition:latest \
  ${internal_reg}/mattermost/mattermost-team-edition:latest
${skopeo_copy} \
  docker://registry.redhat.io/quay/quay-rhel8-operator@sha256:58efe0bae1eab082aff22e9213b94e21456c197543418e2397ca7b3b8d1e739d \
  ${internal_reg}/quay/quay-rhel8-operator@sha256:58efe0bae1eab082aff22e9213b94e21456c197543418e2397ca7b3b8d1e739d
${skopeo_copy} \
  docker://registry.redhat.io/rh-sso-7-tech-preview/sso74-init-container-rhel8:7.4 \
  ${internal_reg}/rh-sso-7-tech-preview/sso74-init-container-rhel8:7.4
${skopeo_copy} \
  docker://registry.redhat.io/rh-sso-7-tech-preview/sso74-rhel8-operator:7.4 \
  ${internal_reg}/rh-sso-7-tech-preview/sso74-rhel8-operator:7.4
${skopeo_copy} \
  docker://registry.redhat.io/rh-sso-7/sso74-openshift-rhel8:7.4 \
  ${internal_reg}/rh-sso-7/sso74-openshift-rhel8:7.4
${skopeo_copy} \
  docker://registry.redhat.io/rhel8/postgresql-10:1 \
  ${internal_reg}/rhel8/postgresql-10:1
${skopeo_copy} \
  docker://registry.redhat.io/rhel8/postgresql-10:latest \
  ${internal_reg}/rhel8/postgresql-10:latest
${skopeo_copy} \
  docker://registry.redhat.io/rhel8/postgresql-96:1 \
  ${internal_reg}/rhel8/postgresql-96:1
${skopeo_copy} \
  docker://registry.redhat.io/rhscl/postgresql-12-rhel7:latest \
  ${internal_reg}/rhscl/postgresql-12-rhel7:latest
${skopeo_copy} \
  docker://registry.redhat.io/rhscl/postgresql-96-rhel7 \
  ${internal_reg}/rhscl/postgresql-96-rhel7
${skopeo_copy} \
    docker://registry.redhat.io/rhscl/postgresql-96-rhel7:latest \
    ${internal_reg}/rhscl/postgresql-96-rhel7:latest
${skopeo_copy} \
    docker://registry.redhat.io/rhscl/redis-32-rhel7:latest \
    ${internal_reg}/rhscl/redis-32-rhel7:latest
${skopeo_copy} \
    docker://quay.io/ploigos/ploigos-base:${tssc_tag} \
    ${internal_reg}/ploigos/ploigos-base:${tssc_tag}
${skopeo_copy} \
    docker://quay.io/ploigos/ploigos-ci-agent-jenkins:${tssc_tag} \
    ${internal_reg}/ploigos/ploigos-ci-agent-jenkins:${tssc_tag}
${skopeo_copy} \
    docker://quay.io/ploigos/ploigos-base-java-8:${tssc_tag} \
    ${internal_reg}/ploigos/ploigos-base-java-8:${tssc_tag}
${skopeo_copy} \
    docker://quay.io/ploigos/ploigos-tool-maven:${tssc_tag} \
    ${internal_reg}/ploigos/ploigos-tool-maven:${tssc_tag}
${skopeo_copy} \
    docker://quay.io/ploigos/ploigos-tool-sonar:${tssc_tag} \
    ${internal_reg}/ploigos/ploigos-tool-sonar:${tssc_tag}
${skopeo_copy} \
    docker://quay.io/ploigos/ploigos-tool-argocd:${tssc_tag} \
    ${internal_reg}/ploigos/ploigos-tool-argocd:${tssc_tag}
${skopeo_copy} \
    docker://quay.io/ploigos/ploigos-tool-config-lint:${tssc_tag} \
    ${internal_reg}/ploigos/ploigos-tool-config-lint:${tssc_tag}
${skopeo_copy} \
    docker://quay.io/ploigos/ploigos-tool-helm:${tssc_tag} \
    ${internal_reg}/ploigos/ploigos-tool-helm:${tssc_tag}
${skopeo_copy} \
    docker://quay.io/ploigos/ploigos-tool-containers:${tssc_tag} \
    ${internal_reg}/ploigos/ploigos-tool-containers:${tssc_tag}
${skopeo_copy} \
    docker://quay.io/ploigos/ploigos-tool-openscap:${tssc_tag} \
    ${internal_reg}/ploigos/ploigos-tool-openscap:${tssc_tag}

${skopeo_copy} \
docker://quay.io/openshift-release-dev/ocp-v4.0-art-dev@sha256:772bfad0055acc94ee7ce9f3ed44008003f5a9b6c05865ec0b6a331c67dda76b \
  ${internal_reg}/openshift-release-dev@sha256:772bfad0055acc94ee7ce9f3ed44008003f5a9b6c05865ec0b6a331c67dda76b

${skopeo_copy} \
docker://quay.io/openshift-release-dev/ocp-v4.0-art-dev@sha256:ae79797901399df5abf6f4afb08451c48f261a10a7c9251447d21396089f87e2 \
  ${internal_reg}/openshift-release-dev@sha256:ae79797901399df5abf6f4afb08451c48f261a10a7c9251447d21396089f87e2

${skopeo_copy} \
docker://quay.io/openshift-release-dev/ocp-v4.0-art-dev@sha256:19757106e33c95c1b7e61338fa7ffe1bb043197292162c3c47b95f2af0d53b58 \
  ${internal_reg}/openshift-release-dev@sha256:19757106e33c95c1b7e61338fa7ffe1bb043197292162c3c47b95f2af0d53b58

${skopeo_copy} \
docker://quay.io/openshift-release-dev/ocp-v4.0-art-dev@sha256:e401ae9497bb32c6e29d46048fd6caf75d02dc775fef96e4d3a9c2f62f389f57 \
  ${internal_reg}/openshift-release-dev/ocp-v4.0-art-dev@sha256:e401ae9497bb32c6e29d46048fd6caf75d02dc775fef96e4d3a9c2f62f389f57

${skopeo_copy} \
docker://quay.io/openshift-release-dev/ocp-v4.0-art-dev@sha256:895b861d68025ca3ae0626f7fc139288d6af87a7c6b84e3faad6d3c3a5581bfa \
  ${internal_reg}/openshift-release-dev/ocp-v4.0-art-dev@sha256:895b861d68025ca3ae0626f7fc139288d6af87a7c6b84e3faad6d3c3a5581bfa


${skopeo_copy} \
docker://quay.io/openshift-release-dev/ocp-v4.0-art-dev@sha256:307b425c8bea5913ea564d06707d4b9dc2263898e26c04ab7eae5dc5133eb982 \
  ${internal_reg}/openshift-release-dev/ocp-v4.0-art-dev@sha256:307b425c8bea5913ea564d06707d4b9dc2263898e26c04ab7eae5dc5133eb982


${skopeo_copy} \
docker://quay.io/openshift-release-dev/ocp-v4.0-art-dev@sha256:772bfad0055acc94ee7ce9f3ed44008003f5a9b6c05865ec0b6a331c67dda76b \
  ${internal_reg}/openshift-release-dev/ocp-v4.0-art-dev@sha256:772bfad0055acc94ee7ce9f3ed44008003f5a9b6c05865ec0b6a331c67dda76b


${skopeo_copy} \
docker://quay.io/openshift-release-dev/ocp-v4.0-art-dev@sha256:a623d0bd671a449d7c5b43bf22a839717a0210b4bd7f896bc7448214a0cae293 \
  ${internal_reg}/openshift-release-dev/ocp-v4.0-art-dev@sha256:a623d0bd671a449d7c5b43bf22a839717a0210b4bd7f896bc7448214a0cae293


${skopeo_copy} \
docker://quay.io/openshift-release-dev/ocp-v4.0-art-dev@sha256:307b425c8bea5913ea564d06707d4b9dc2263898e26c04ab7eae5dc5133eb982 \
  ${internal_reg}/openshift-release-dev/ocp-v4.0-art-dev@sha256:307b425c8bea5913ea564d06707d4b9dc2263898e26c04ab7eae5dc5133eb982

  ${skopeo_copy} \
docker://quay.io/openshift-release-dev/ocp-release@sha256:d74b1cfa81f8c9cc23336aee72d8ae9c9905e62c4874b071317a078c316f8a70 \
  ${internal_reg}/openshift-release-dev/ocp-release@sha256:d74b1cfa81f8c9cc23336aee72d8ae9c9905e62c4874b071317a078c316f8a70
 
 ${skopeo_copy} \
docker://quay.io/openshift-release-dev/ocp-v4.0-art-dev@sha256:94ecbd40c1044136419ea91b8655fa8f63cd32ef6ac8fc996981a1ac387be944 \
  ${internal_reg}/openshift-release-dev/ocp-v4.0-art-dev@sha256:94ecbd40c1044136419ea91b8655fa8f63cd32ef6ac8fc996981a1ac387be944

   ${skopeo_copy} \
docker://quay.io/openshift-release-dev/ocp-v4.0-art-dev@sha256:10a4f8b6140d61888f8707905309a0e7ed7f6eae6b5c59d42b263e58e24271c0 \
  ${internal_reg}/openshift-release-devocp-v4.0-art-dev@sha256:10a4f8b6140d61888f8707905309a0e7ed7f6eae6b5c59d42b263e58e24271c0

   ${skopeo_copy} \
docker://quay.io/openshift-release-dev/ocp-v4.0-art-dev@sha256:772bfad0055acc94ee7ce9f3ed44008003f5a9b6c05865ec0b6a331c67dda76b \
  ${internal_reg}/openshift-release-dev/ocp-v4.0-art-dev@sha256:772bfad0055acc94ee7ce9f3ed44008003f5a9b6c05865ec0b6a331c67dda76b

   ${skopeo_copy} \
docker://quay.io/openshift-release-dev/ocp-v4.0-art-dev@sha256:772bfad0055acc94ee7ce9f3ed44008003f5a9b6c05865ec0b6a331c67dda76b \
  ${internal_reg}/openshift-release-dev/ocp-v4.0-art-dev@sha256:772bfad0055acc94ee7ce9f3ed44008003f5a9b6c05865ec0b6a331c67dda76b
  
     ${skopeo_copy} \
docker://quay.io/openshift-release-dev/ocp-release@sha256:d74b1cfa81f8c9cc23336aee72d8ae9c9905e62c4874b071317a078c316f8a70 \
  ${internal_reg}/openshift-release-dev/ocp-release@sha256:772bfad0055acc94ee7ce9f3ed44008003f5a9b6c05865ec0b6a331c67dda76b
  
${skopeo_copy} \
docker://quay.io/openshift-release-dev/ocp-v4.0-art-dev@sha256:19757106e33c95c1b7e61338fa7ffe1bb043197292162c3c47b95f2af0d53b58 \
  ${internal_reg}/openshift-release-dev/ocp-v4.0-art-dev@sha256:19757106e33c95c1b7e61338fa7ffe1bb043197292162c3c47b95f2af0d53b58

${skopeo_copy} \
docker://quay.io/openshift-release-dev/ocp-v4.0-art-dev@sha256:e401ae9497bb32c6e29d46048fd6caf75d02dc775fef96e4d3a9c2f62f389f57 \
  ${internal_reg}/openshift-release-dev/ocp-v4.0-art-dev@sha256:e401ae9497bb32c6e29d46048fd6caf75d02dc775fef96e4d3a9c2f62f389f57

${skopeo_copy} \
docker://quay.io/openshift-release-dev/ocp-v4.0-art-dev@sha256:895b861d68025ca3ae0626f7fc139288d6af87a7c6b84e3faad6d3c3a5581bfa \
  ${internal_reg}/openshift-release-dev/ocp-v4.0-art-dev@sha256:895b861d68025ca3ae0626f7fc139288d6af87a7c6b84e3faad6d3c3a5581bfa


${skopeo_copy} \
docker://quay.io/openshift-release-dev/ocp-v4.0-art-dev@sha256:307b425c8bea5913ea564d06707d4b9dc2263898e26c04ab7eae5dc5133eb982 \
  ${internal_reg}/openshift-release-dev/ocp-v4.0-art-dev@sha256:307b425c8bea5913ea564d06707d4b9dc2263898e26c04ab7eae5dc5133eb982


${skopeo_copy} \
docker://quay.io/openshift-release-dev/ocp-v4.0-art-dev@sha256:772bfad0055acc94ee7ce9f3ed44008003f5a9b6c05865ec0b6a331c67dda76b \
  ${internal_reg}/openshift-release-dev/ocp-v4.0-art-dev@sha256:772bfad0055acc94ee7ce9f3ed44008003f5a9b6c05865ec0b6a331c67dda76b


${skopeo_copy} \
docker://quay.io/openshift-release-dev/ocp-v4.0-art-dev@sha256:a623d0bd671a449d7c5b43bf22a839717a0210b4bd7f896bc7448214a0cae293 \
  ${internal_reg}/openshift-release-dev/ocp-v4.0-art-dev@sha256:a623d0bd671a449d7c5b43bf22a839717a0210b4bd7f896bc7448214a0cae293


${skopeo_copy} \
docker://quay.io/openshift-release-dev/ocp-v4.0-art-dev@sha256:307b425c8bea5913ea564d06707d4b9dc2263898e26c04ab7eae5dc5133eb982 \
  ${internal_reg}/openshift-release-dev/ocp-v4.0-art-dev@sha256:307b425c8bea5913ea564d06707d4b9dc2263898e26c04ab7eae5dc5133eb982

  ${skopeo_copy} \
docker://quay.io/openshift-release-dev/ocp-release@sha256:d74b1cfa81f8c9cc23336aee72d8ae9c9905e62c4874b071317a078c316f8a70 \
  ${internal_reg}/openshift-release-dev/ocp-release@sha256:d74b1cfa81f8c9cc23336aee72d8ae9c9905e62c4874b071317a078c316f8a70
 
 ${skopeo_copy} \
docker://quay.io/openshift-release-dev/ocp-v4.0-art-dev@sha256:94ecbd40c1044136419ea91b8655fa8f63cd32ef6ac8fc996981a1ac387be944 \
  ${internal_reg}/openshift-release-dev/ocp-v4.0-art-dev@sha256:94ecbd40c1044136419ea91b8655fa8f63cd32ef6ac8fc996981a1ac387be944

   ${skopeo_copy} \
docker://quay.io/openshift-release-dev/ocp-v4.0-art-dev@sha256:10a4f8b6140d61888f8707905309a0e7ed7f6eae6b5c59d42b263e58e24271c0 \
  ${internal_reg}/openshift-release-dev/ocp-v4.0-art-dev@sha256:10a4f8b6140d61888f8707905309a0e7ed7f6eae6b5c59d42b263e58e24271c0

   ${skopeo_copy} \
docker://quay.io/openshift-release-dev/ocp-v4.0-art-dev@sha256:772bfad0055acc94ee7ce9f3ed44008003f5a9b6c05865ec0b6a331c67dda76b \
  ${internal_reg}/openshift-release-dev/ocp-v4.0-art-dev@sha256:772bfad0055acc94ee7ce9f3ed44008003f5a9b6c05865ec0b6a331c67dda76b

   ${skopeo_copy} \
docker://quay.io/openshift-release-dev/ocp-v4.0-art-dev@sha256:772bfad0055acc94ee7ce9f3ed44008003f5a9b6c05865ec0b6a331c67dda76b \
  ${internal_reg}/openshift-release-dev/ocp-v4.0-art-dev@sha256:772bfad0055acc94ee7ce9f3ed44008003f5a9b6c05865ec0b6a331c67dda76b
  
     ${skopeo_copy} \
docker://quay.io/openshift-release-dev/ocp-release@sha256:d74b1cfa81f8c9cc23336aee72d8ae9c9905e62c4874b071317a078c316f8a70 \
  ${internal_reg}/openshift-release-dev/ocp-release@sha256:772bfad0055acc94ee7ce9f3ed44008003f5a9b6c05865ec0b6a331c67dda76b

   ${skopeo_copy} \
docker://quay.io/openshift-release-dev/ocp-v4.0-art-dev@sha256:b351d835fd1a99b99b97586ca641042ebfd7478f5f6f6c45757482e6b717fa25 \
  ${internal_reg}/openshift-release-dev/ocp-v4.0-art-dev@sha256:b351d835fd1a99b99b97586ca641042ebfd7478f5f6f6c45757482e6b717fa25  

   ${skopeo_copy} \
docker://quay.io/openshift-release-dev/ocp-v4.0-art-dev@sha256:4b283e711b616610bd0c4fac72cee7bc07343036e3b1ef36cd66d21209fb0906 \
  ${internal_reg}/openshift-release-dev/ocp-v4.0-art-dev@sha256:4b283e711b616610bd0c4fac72cee7bc07343036e3b1ef36cd66d21209fb0906    

   ${skopeo_copy} \
docker://quay.io/openshift-release-dev/ocp-v4.0-art-dev@sha256:19757106e33c95c1b7e61338fa7ffe1bb043197292162c3c47b95f2af0d53b58 \
  ${internal_reg}/openshift-release-dev/ocp-v4.0-art-dev@sha256:19757106e33c95c1b7e61338fa7ffe1bb043197292162c3c47b95f2af0d53b58      

   ${skopeo_copy} \
docker://quay.io/openshift-release-dev/ocp-v4.0-art-dev@sha256:f1e82f08e81f929146e4ea9865d8f384adb324b2316519a51f5ac2671b9e160a \
  ${internal_reg}/openshift-release-dev@sha256:f1e82f08e81f929146e4ea9865d8f384adb324b2316519a51f5ac2671b9e160a     

   ${skopeo_copy} \
docker://quay.io/openshift-release-dev/ocp-v4.0-art-dev@sha256:1e8cdc0cadf06b272fa20efefb7b5e215c49a3d8f011f47b3789cf31f6e9541a \
  ${internal_reg}/openshift-release-dev/ocp-v4.0-art-dev@sha256:1e8cdc0cadf06b272fa20efefb7b5e215c49a3d8f011f47b3789cf31f6e9541a       

    ${skopeo_copy} \
docker://registry.redhat.io/redhat/redhat-marketplace-index:v4.7 \
  ${internal_reg}/redhat/redhat-marketplace-index:v4.7     

   ${skopeo_copy} \
docker://quay.io/openshift-release-dev/ocp-v4.0-art-dev@sha256:ae79797901399df5abf6f4afb08451c48f261a10a7c9251447d21396089f87e2 \
  ${internal_reg}/openshift-release-dev@sha256:ae79797901399df5abf6f4afb08451c48f261a10a7c9251447d21396089f87e2

   ${skopeo_copy} \
docker://quay.io/openshift-release-dev/ocp-v4.0-art-dev@sha256:e580df078522fed0d83f516fc9c3c21409b113a4e00973670884603c58e4a05e \
  ${internal_reg}/openshift-release-dev@sha256:e580df078522fed0d83f516fc9c3c21409b113a4e00973670884603c58e4a05e  

   ${skopeo_copy} \
docker://quay.io/openshift-release-dev/ocp-v4.0-art-dev@sha256:4bf1837c729641f1653d86dadc3690377ffc68b27c010b47cf2b23a45c8bfc00 \
  ${internal_reg}/openshift-release-dev/ocp-v4.0-art-dev@sha256:4bf1837c729641f1653d86dadc3690377ffc68b27c010b47cf2b23a45c8bfc00

     ${skopeo_copy} \
docker://quay.io/openshift-release-dev/ocp-v4.0-art-dev@sha256:bef4ea85c2ffbb2800380531d3cc31b37180bf4beddc97eb5309bd5afb50592d \
  ${internal_reg}/openshift-release-dev/ocp-v4.0-art-dev@sha256:bef4ea85c2ffbb2800380531d3cc31b37180bf4beddc97eb5309bd5afb50592d

     ${skopeo_copy} \
docker://quay.io/openshift-release-dev/ocp-v4.0-art-dev@sha256:78bc86b3ad4a53f4f5cd2b2d6bfdaa240db9b0de0200de4749e3214e776846af \
  ${internal_reg}/openshift-release-dev/ocp-v4.0-art-dev@sha256:78bc86b3ad4a53f4f5cd2b2d6bfdaa240db9b0de0200de4749e3214e776846af  

     ${skopeo_copy} \
docker://quay.io/openshift-release-dev/ocp-v4.0-art-dev@sha256:1e8cdc0cadf06b272fa20efefb7b5e215c49a3d8f011f47b3789cf31f6e9541a \
  ${internal_reg}/openshift-release-dev/ocp-v4.0-art-dev@sha256:1e8cdc0cadf06b272fa20efefb7b5e215c49a3d8f011f47b3789cf31f6e9541a    

    ${skopeo_copy} \
docker://registry.redhat.io/redhat/community-operator-index:v4.7 \
  ${internal_reg}/redhat/community-operator-index:v4.7     

       ${skopeo_copy} \
docker://quay.io/openshift-release-dev/ocp-v4.0-art-dev@sha256:ae79797901399df5abf6f4afb08451c48f261a10a7c9251447d21396089f87e2 \
  ${internal_reg}/openshift-release-dev/ocp-v4.0-art-dev@sha256:ae79797901399df5abf6f4afb08451c48f261a10a7c9251447d21396089f87e2    

         ${skopeo_copy} \
docker://quay.io/openshift-release-dev/ocp-v4.0-art-dev@sha256:94ecbd40c1044136419ea91b8655fa8f63cd32ef6ac8fc996981a1ac387be944 \
  ${internal_reg}/openshift-release-dev/ocp-v4.0-art-dev@sha256:94ecbd40c1044136419ea91b8655fa8f63cd32ef6ac8fc996981a1ac387be944    

         ${skopeo_copy} \
docker://quay.io/openshift-release-dev/ocp-v4.0-art-dev@sha256:10a4f8b6140d61888f8707905309a0e7ed7f6eae6b5c59d42b263e58e24271c0 \
  ${internal_reg}/openshift-release-dev/ocp-v4.0-art-dev@sha256:10a4f8b6140d61888f8707905309a0e7ed7f6eae6b5c59d42b263e58e24271c0     

         ${skopeo_copy} \
docker://quay.io/openshift-release-dev/ocp-v4.0-art-dev@sha256:a623d0bd671a449d7c5b43bf22a839717a0210b4bd7f896bc7448214a0cae293 \
  ${internal_reg}/openshift-release-dev/ocp-v4.0-art-dev@sha256:a623d0bd671a449d7c5b43bf22a839717a0210b4bd7f896bc7448214a0cae293       

         ${skopeo_copy} \
docker://quay.io/openshift-release-dev/ocp-v4.0-art-dev@sha256:772bfad0055acc94ee7ce9f3ed44008003f5a9b6c05865ec0b6a331c67dda76b \
  ${internal_reg}/openshift-release-dev/ocp-v4.0-art-dev@sha256:772bfad0055acc94ee7ce9f3ed44008003f5a9b6c05865ec0b6a331c67dda76b   

         ${skopeo_copy} \
docker://quay.io/openshift-release-dev/ocp-v4.0-art-dev@sha256:772bfad0055acc94ee7ce9f3ed44008003f5a9b6c05865ec0b6a331c67dda76b \
  ${internal_reg}/openshift-release-dev/ocp-v4.0-art-dev@sha256:772bfad0055acc94ee7ce9f3ed44008003f5a9b6c05865ec0b6a331c67dda76b

         ${skopeo_copy} \
docker://quay.io/openshift-release-dev/ocp-v4.0-art-dev@sha256:307b425c8bea5913ea564d06707d4b9dc2263898e26c04ab7eae5dc5133eb982 \
  ${internal_reg}/openshift-release-dev/ocp-v4.0-art-dev@sha256:307b425c8bea5913ea564d06707d4b9dc2263898e26c04ab7eae5dc5133eb982          

         ${skopeo_copy} \
docker://quay.io/openshift-release-dev/ocp-v4.0-art-dev@sha256:784d05992a7a449a4fbc66074597c84b555efa90b1df51cba8520787de9335cd \
  ${internal_reg}/openshift-release-dev/ocp-v4.0-art-dev@sha256:784d05992a7a449a4fbc66074597c84b555efa90b1df51cba8520787de9335cd     

          ${skopeo_copy} \
docker://quay.io/openshift-release-dev/ocp-v4.0-art-dev@sha256:d9649eaed742c7c53e01326f6a9871d5597e9e7ef8abc7006f2cd2763e2a5b15 \
  ${internal_reg}/openshift-release-dev/ocp-v4.0-art-dev@sha256:d9649eaed742c7c53e01326f6a9871d5597e9e7ef8abc7006f2cd2763e2a5b15     

          ${skopeo_copy} \
docker://quay.io/openshift-release-dev/ocp-v4.0-art-dev@sha256:df9b1e1d04ada670d627e906e80b25ea9c33dc23d439a80bbf10de0758d22e0b \
  docker://18.252.71.151:5000/openshift-release-dev/ocp-v4.0-art-dev@sha256:df9b1e1d04ada670d627e906e80b25ea9c33dc23d439a80bbf10de0758d22e0b

skopeo copy --all --dest-tls-verify=false --authfile ~/.docker/config.json docker://registry.redhat.io/redhat/redhat-operator-index:v4.7 ${internal_reg}/redhat/redhat-operator-index:v4.7

skopeo copy --all --dest-tls-verify=false --authfile ~/.docker/config.json docker://registry.redhat.io/redhat/redhat-operator-index:v4.7 ${internal_reg}/redhat/redhat-operator-index:v4.7

skopeo copy --all --dest-tls-verify=false --authfile ~/.docker/config.json docker://registry.redhat.io/redhat/certified-operator-index:v4.7 ${internal_reg}/redhat/certified-operator-index:v4.7

skopeo copy --all --dest-tls-verify=false --authfile ~/.docker/config.json docker://quay.io/openshift-release-dev/ocp-v4.0-art-dev@sha256:05302fab01c683af02c51571dae4211c02774bab7cb02c8ac65495f055149722 ${internal_reg}/openshift-release-dev@sha256:05302fab01c683af02c51571dae4211c02774bab7cb02c8ac65495f055149722

skopeo copy --all --dest-tls-verify=false --authfile ~/.docker/config.json docker://quay.io/openshift-release-dev/ocp-v4.0-art-dev@sha256:a8492014930da85a4ed1036a4d1f6907c1a7cf76fffae7490ea7e18a89cdfd10 ${internal_reg}/openshift-release-dev@sha256:a8492014930da85a4ed1036a4d1f6907c1a7cf76fffae7490ea7e18a89cdfd10

skopeo copy --all --dest-tls-verify=false --authfile ~/.docker/config.json docker://quay.io/openshift-release-dev/ocp-v4.0-art-dev@sha256:764ed0b5a79f750aae88f9f17dbf74c8b6134b39010c28c182d6a6fd6be40b1d ${internal_reg}/openshift-release-dev@sha256:764ed0b5a79f750aae88f9f17dbf74c8b6134b39010c28c182d6a6fd6be40b1d

skopeo copy --all --dest-tls-verify=false --authfile ~/.docker/config.json docker://quay.io/openshift-release-dev/ocp-v4.0-art-dev@sha256:30d25b2bd9a7bd9ff59ed4fe15fe3b2628f09993004fd4bf318a80ab0715809c ${internal_reg}/openshift-release-dev@sha256:30d25b2bd9a7bd9ff59ed4fe15fe3b2628f09993004fd4bf318a80ab0715809c

skopeo copy --all --dest-tls-verify=false --authfile ~/.docker/config.json docker://quay.io/openshift-release-dev/ocp-v4.0-art-dev@sha256:08d81d44f449025c59b133fd040f01423c090ac043a632b30880caf8d725b7e6 ${internal_reg}/openshift-release-dev@sha256:08d81d44f449025c59b133fd040f01423c090ac043a632b30880caf8d725b7e6

skopeo copy --all --dest-tls-verify=false --authfile ~/.docker/config.json docker://quay.io/openshift-release-dev/ocp-v4.0-art-dev@sha256:0ef1757a9334675bfd06275e1ed53af30f31a88ad8c711b19833e3a9539aa932 ${internal_reg}/openshift-release-dev@sha256:0ef1757a9334675bfd06275e1ed53af30f31a88ad8c711b19833e3a9539aa932
