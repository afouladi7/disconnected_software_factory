#!/bin/bash

read -p "Please enter the internal IP of your Container Registry: " ip


echo 'unqualified-search-registries = ["registry.access.redhat.com", "registry.redhat.io", "quay.io", "docker.io"]

[[registry]]
  prefix = ""
  location = "docker.io/argoproj"
  mirror-by-digest-only = false

  [[registry.mirror]]
    location = "'${ip}':5000/argoproj"
    insecure = true

[[registry]]
  prefix = ""
  location = "docker.io/library"
  mirror-by-digest-only = false

  [[registry.mirror]]
    location = "'${ip}':5000/library"
    insecure = true

[[registry]]
  prefix = ""
  location = "gcr.io/kubebuilder"
  mirror-by-digest-only = false

  [[registry.mirror]]
    location = "'${ip}':5000/kubebuilder"
    insecure = true

[[registry]]
  prefix = ""
  location = "quay.io/akrohg"
  mirror-by-digest-only = false

  [[registry.mirror]]
    location = "'${ip}':5000/akrohg"
    insecure = true

[[registry]]
  prefix = ""
  location = "quay.io/redhat-cop"
  mirror-by-digest-only = false

  [[registry.mirror]]
    location = "'${ip}':5000/redhat-cop"
    insecure = true

[[registry]]
  prefix = ""
  location = "quay.io/openshift-release-dev/ocp-release"
  mirror-by-digest-only = false

  [[registry.mirror]]
    location = "'${ip}':5000/openshift-release-dev"
    insecure = true

[[registry]]
  prefix = ""
  location = "quay.io/openshift-release-dev/ocp-v4.0-art-dev"
  mirror-by-digest-only = false

  [[registry.mirror]]
    location = "'${ip}':5000/openshift-release-dev"
    insecure = true

[[registry]]
  prefix = ""
  location = "quay.io/redhatgov"
  mirror-by-digest-only = false

  [[registry.mirror]]
    location = "'${ip}':5000/redhatgov"
    insecure = true

[[registry]]
  prefix = ""
  location = "registry.connect.redhat.com"
  mirror-by-digest-only = false

  [[registry.mirror]]
    location = "'${ip}':5000"
    insecure = true

[[registry]]
  prefix = ""
  location = "registry.redhat.io"
  mirror-by-digest-only = false

  [[registry.mirror]]
    location = "'${ip}':5000"
    insecure = true' > mirror.conf
