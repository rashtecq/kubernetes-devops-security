#!/bin/bash
sleep 60s

if [[ $(kubectl rollout status deploy ${deploymentName} -n prod --timeout 5s) != *"successfully rolled out"* ]];
then 
    echo "Deployment ${deploymentName} rollout has Failed"
    kubectl rollout undo deploy $deploymentName -n prod 
    exit 1;
else
    echo "Deployment ${deploymentName} Rollout is Succesfull"
fi

