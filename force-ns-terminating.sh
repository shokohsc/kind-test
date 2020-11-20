#!/bin/bash

# https://medium.com/@craignewtondev/how-to-fix-kubernetes-namespace-deleting-stuck-in-terminating-state-5ed75792647e

namespace=$1
force=$2
if [ "$namespace" = "" ]; then
  echo "You need to enter a namespace name"
  exit 1
fi

if [ "$force" = "--force" ]; then
  kubectl get namespace $namespace -o json > ${namespace}.json
  sed -i -e '/"kubernetes"/g' ${namespace}.json
  kubectl replace --raw "/api/v1/namespaces/${namespace}/finalize" -f ./${namespace}.json
else
  echo "You are going to edit namespace: ${namespace}"
  echo "If you are sure about that, replay the command with the parameter '--force' after the namespace."
  exit 0
fi

