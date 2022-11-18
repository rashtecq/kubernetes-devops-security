dockerImageName=$(awk 'NR==1 {print $2}' Dockerfile)
echo $dockerImageName

docker run --rm -v $WORKSPACE:/root/.cache/ aquasec/trivy:0.34.0 -q image --exit-code 0 --severity HIGH --light $dockerImageName
docker run --rm -v $WORKSPACE:/root/.cache/ aquasec/trivy:0.34.0 -q image --exit-code 1 --severity CRITICAL --light $dockerImageName

#Trivy scan result result processing
  exit_code=$?
  echo "Exit Code: $exit_code"

#check the scan result
  if [["${exit_code}" == 1 ]]; then
      echo "Image scanning failed. Vulnerability found"
  else
    echo "Image scanning passed. No Vulnerability found"
  fi;