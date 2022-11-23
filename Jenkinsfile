pipeline {
  agent any
  environment {
    deploymentName = "devsecops"
    containerName = "devsecops-container"
    serviceName = "devsecops-svc"
    imageName = "rashtecq/numeric-app:${GIT_COMMIT}"
    application_URL = "http://devsecops-demo.eastus.cloudapp.azure.com"
    applicationURI = "/increment/99"

  }

  stages {
      stage('Build Artifact') {
            steps {
              sh "mvn clean package -DskipTests=true"
              archive 'target/*.jar'
            }
        }
      stage('Unit  Testing - JUnit and Jacoco') {
          steps {
            sh "mvn test"
            }
            post {
              always {
               junit 'target/surefire-reports/*.xml'
               jacoco execPattern:'target/jacoco.exec'
               }
            }
          }
      stage('Mutation Tests - PIT'){
        steps {
            sh "mvn org.pitest:pitest-maven:mutationCoverage"
        }
        post {
          always {
          pitmutation mutationStatsFile: '**/target/pit-reports/**/mutations.xml'
          }
        }
      }
      stage('SonarQube - SAST') {
        steps {
           withSonarQubeEnv('SonarQube'){
            sh "mvn clean verify sonar:sonar -Dsonar.projectKey=numeric-application -Dsonar.host.url=http://devsecops-rashtecq.eastus.cloudapp.azure.com:9000 -Dsonar.login=sqp_afbf2b97fa3b26d1bf188692f07df67af8c8c7c0"
            }
           timeout(time:2, unit: 'MINUTES'){
              script {
                waitForQualityGate abortPipeline: true
              }
           }
        }
      }
      stage('Vulnerability Scan - Docker'){
        steps {
            parallel(
                "Dependency Scan":{
                    sh "mvn dependency-check:check"
                },
                "Trivy Scan":{
                    sh "bash trivy-docker-image-scan.sh"
                },
                "OPA Conftest":{
                    sh 'docker run --rm -v $(pwd):/project openpolicyagent/conftest test --policy opa-docker-security.rego Dockerfile'
                }
            )
        }

        post {
            always {
                dependencyCheckPublisher pattern: 'target/dependency-check-report.xml'
            }
        }
      }

      stage('Docker ImageBuild & Push2DockerHub') {
          steps{
            withDockerRegistry([credentialsId: "docker-hub", url: ""]){
            sh 'printenv'
            sh 'sudo docker build -t rashtecq/numeric-app:""$GIT_COMMIT"" .'
            sh 'docker push rashtecq/numeric-app:""$GIT_COMMIT""'
             }
            }
          }
      stage('Vulnerability Scan - Kubernetes') {
        steps{
          parallel(
            "OPA Scan": {
              sh 'docker run --rm -v $(pwd):/project openpolicyagent/conftest test --policy opa-k8s-security.rego k8s_deployment_service.yaml'
            },
            "Kubesec Scan": {
              sh 'bash kubesec-scan.sh'
            },
            "Trivy Scan": {
              sh 'bash trivy-k8s-scan.sh'
            }

          )
        }
      }    
      stage ('Kubernetes Deployment - DEV'){
         steps{
            withKubeConfig([credentialsId: "kubeconfig"]){
            sh "sed -i 's#replace#rashtecq/numeric-app:${GIT_COMMIT}#g' k8s_deployment_service.yaml"
            sh "kubectl apply -f k8s_deployment_service.yaml"
          }
        }

      }
  }
 }