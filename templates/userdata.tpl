#!/bin/bash
set -o xtrace
/etc/eks/bootstrap.sh --use-max-pods '${use_max_pods}' --apiserver-endpoint '${cluster_endpoint}' --b64-cluster-ca '${cluster_certificate}' '${cluster_name}'
