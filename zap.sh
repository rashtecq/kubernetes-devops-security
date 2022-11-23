#!/bin/bash
PORT=$(kubectl -n default get svc ${service_name} -o json | jq .spec.ports[].nodePort)

chmod 777 $(pwd)
echo $(id -u):$(id -g)
docker run -v $(pwd):/zap/wrk/:rw -t owasp/zap2docker-weekly zap-api-scan.py -t $applicationURL:$PORT/v3/api-docs -f openssl -r zap_report.html

exit_code=$?

#HTML report
sudo mkdir -p owasp-zap-report
sudo mv zap_report.html owasp-zap-report


echo "Exit Code : $exit_code"
if [[ ${exit_code -ne 0 }]]; then
    echo "OWASP report has either Low/Medium/High Risk. Please check the HTML report"
    exit 1;
    else
    echo "OWASP ZAP didnot report any Risk"
fi;
