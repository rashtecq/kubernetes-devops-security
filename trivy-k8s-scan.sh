echo $imageName #Getting name from environemtn variable
docker run --rm -v $WORKSPACE:/root/.cache/ aquasec/trivy -q image --exit-code 0 --severity LOW,MEDIUM,HIGH --light $dockerImageName
docker run --rm -v $WORKSPACE:/root/.cache/ aquasec/trivy -q image --exit-code 1 --severity CRITICAL --light $dockerImageName

#Trivy scan result result processing
  exit_code=$?
  echo "Exit Code: $exit_code"

#check the scan result
  if [[ "${exit_code}" == 1 ]]; then
      echo "Image scanning failed. CRITICAL severity Vulnerability found"
  else
    echo "Image scanning passed. No CRITICAL severity Vulnerability found"
  fi;