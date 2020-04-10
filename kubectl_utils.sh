#!/bin/bash

# Assign command and options
command_name=$1
namespace=$2
pod=$3

if [ -z $namespace ]
then
  namespace="default"
fi
if [ -z $pod ]
then
  pod="app"
fi

exec_help() {
  echo "./kubectl_utils.sh [command] [namespace] [pod]
  command: help, list_pods, logs
  "
}

get_pods_command() {
  echo "kubectl -n $namespace get pods"
}

exec_list_pods() {
  cmd=$(get_pods_command)
  $cmd
}

exec_logs() {
  get_pods_cmd=$(get_pods_command)
  pod_id=$($get_pods_cmd | grep "^$pod" | grep "^[[:alnum:]-]*" -o)
  kubectl -n $namespace logs $pod_id -f --tail 500 | grep -v hello | grep -v ping
}

case $command_name in
  help)
    exec_help
    ;;
  list_pods)
    exec_list_pods
    ;;
  logs)
    exec_logs
    ;;
  *)
    exec_help
esac
