pipeline {
    agent any 

    environment {
        // Change this to your actual DockerHub ID
        DOCKER_USER = 'omergldb'
    }

    triggers {
        cron('H 0 * * *') // Automated Midnight Regression
    }

    stages {
        stage('Pull from GitHub') {
            steps {
                checkout scm 
            }
        }

        stage('Build & Tag') {
            steps {
                // Requirement 1: Build using app source and BUILD_ID tag
                sh "docker build -t ${DOCKER_USER}/cicd-demo:${env.BUILD_ID} ."
            }
        }

        stage('Push to DockerHub') {
            steps {
                // Requirement 2: Link to account and push for accessibility
                withCredentials([usernamePassword(credentialsId: 'dockerhub-creds', 
                                 passwordVariable: 'PASS', usernameVariable: 'USER')]) {
                    sh "docker login -u ${USER} -p ${PASS}"
                    sh "docker push ${DOCKER_USER}/cicd-demo:${env.BUILD_ID}"
                }
            }
        }

        stage('Deploy to QA') {
            steps {
                // Requirement 3: Utilize Ansible to deploy to Server 2
                sh "ansible-playbook -i hosts.ini deploy.yml -e 'target_env=qa img_tag=${env.BUILD_ID}'"
            }
        }

        stage('Deploy to Staging') {
            steps {
                // Deploy to Server 3 only if QA succeeded
                sh "ansible-playbook -i hosts.ini deploy.yml -e 'target_env=staging img_tag=${env.BUILD_ID}'"
            }
        }
    }

    post {
        success {
            echo "Regression Passed! Tag: ${env.BUILD_ID}"
            sh "docker rmi ${DOCKER_USER}/cicd-demo:${env.BUILD_ID}"
        }
        always {
            cleanWs()
        }
    }
}