#Using kubesec v2  API for scanning
scan_result=$(curl -sSX POST --data-binary @"k8s_deployment_service.yaml" https://v2.kubesec.io/scan)
scan_message=$(curl -sSX POST --data-binary @"k8s_deployment_service.yaml" https://v2.kubesec.io/scan| jq .[0].message -r)
scan_score=$(curl -sSX POST --data-binary @"k8s_deployment_service.yaml" https://v2.kubesec.io/scan| jq .[0].score)


#Using kubesec docker image for scanning
#scan_result=$(docker run -i kubesec/kubesec:512c5e0 scan /dev/stdin < k8s_deployment_service.yaml)
#scan_message=$(docker run -i kubesec/kubesec:512c5e0 scan /dev/stdin < k8s_deployment_service.yaml| jq .[0].message -r)
#scan_score=$(docker run -i kubesec/kubesec:512c5e0 scan /dev/stdin < k8s_deployment_service.yaml| jq .[0].score)

#kubesec scan result processing 
# echo "scan_score : $scan_score"
if [[ "${scan_score}" -ge 0 ]]; then 
    echo "Score is $scan_score"
    echo "kubesec Scan $scan_message"
else
    echo "Score is $scan_score, which is less then or equal to 5"
    echo "Scaning kubernetes Resource has failed"
    exit 1;
fi;
