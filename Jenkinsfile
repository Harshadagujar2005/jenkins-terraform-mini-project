pipeline {
    agent any

    environment {
        IMAGE_NAME = 'mini-app'
        IMAGE_TAG  = "${env.BUILD_NUMBER}"
        APP_PORT   = '3000'
    }

    parameters {
        booleanParam(name: 'APPLY_AWS', defaultValue: false,
                     description: 'Tick only if you have an AWS account + Jenkins credential "aws-creds". Otherwise AWS is plan-only (no account needed).')
    }

    options {
        timestamps()
        disableConcurrentBuilds()
    }

    stages {
        stage('Checkout') {
            steps {
                // Pulls the code from the Git repository configured in the Jenkins job
                checkout scm
            }
        }

        stage('Install Dependencies') {
            steps {
                sh 'node --version && npm --version'
                sh 'npm install'
            }
        }

        stage('Test') {
            steps {
                sh 'npm test'
            }
        }

        stage('Build Docker Image') {
            steps {
                sh 'docker build -t ${IMAGE_NAME}:${IMAGE_TAG} .'
            }
        }

        // ---------- Terraform: AWS cloud infrastructure (plan works without an AWS account) ----------
        stage('Terraform AWS: Init & Validate') {
            steps {
                dir('terraform/aws') {
                    sh 'terraform init -input=false'
                    sh 'terraform fmt -recursive'
                    sh 'terraform validate'
                }
            }
        }

        stage('Terraform AWS: Plan') {
            steps {
                dir('terraform/aws') {
                    sh 'terraform plan -input=false -no-color -var="use_mock_credentials=true" | tee aws-plan.txt'
                }
                archiveArtifacts artifacts: 'terraform/aws/aws-plan.txt', allowEmptyArchive: true
            }
        }

        stage('Terraform AWS: Apply (optional)') {
            when { expression { return params.APPLY_AWS == true } }
            steps {
                withCredentials([usernamePassword(credentialsId: 'aws-creds',
                                                  usernameVariable: 'AWS_ACCESS_KEY_ID',
                                                  passwordVariable: 'AWS_SECRET_ACCESS_KEY')]) {
                    dir('terraform/aws') {
                        sh 'terraform apply -auto-approve -input=false -var="use_mock_credentials=false"'
                    }
                }
            }
        }

        // ---------- Terraform: local Docker deployment (real apply, no cloud needed) ----------
        stage('Terraform Docker: Init & Validate') {
            steps {
                dir('terraform/docker') {
                    sh 'terraform init -input=false'
                    sh 'terraform fmt -recursive'
                    sh 'terraform validate'
                }
            }
        }

        stage('Terraform Docker: Plan') {
            steps {
                dir('terraform/docker') {
                    sh 'terraform plan -input=false -var="image_name=${IMAGE_NAME}" -var="image_tag=${IMAGE_TAG}" -var="external_port=${APP_PORT}"'
                }
            }
        }

        stage('Deploy (Terraform Apply)') {
            steps {
                dir('terraform/docker') {
                    sh 'terraform apply -auto-approve -input=false -var="image_name=${IMAGE_NAME}" -var="image_tag=${IMAGE_TAG}" -var="external_port=${APP_PORT}"'
                }
            }
        }

        stage('Verify Deployment') {
            steps {
                // host.docker.internal = the machine running Docker (where the app container publishes its port)
                sh '''
                    for i in 1 2 3 4 5 6 7 8 9 10; do
                      if curl -fsS http://host.docker.internal:${APP_PORT}/health; then
                        echo; echo "Deployment verified."; exit 0
                      fi
                      echo "Waiting for app..."; sleep 3
                    done
                    echo "App did not become healthy"; exit 1
                '''
            }
        }
    }

    post {
        success { echo 'Pipeline succeeded. App is running at http://localhost:3000' }
        failure { echo 'Pipeline failed. Check the stage logs above.' }
    }
}
