pipeline {
    agent any
    environment {
        DOCKER_CREDS_ID = 'dockerhub-creds'
    }
    stages {
        stage('Checkout') {
            steps {
                git branch: 'main', url: 'https://github.com/omergldb-ops/cicd-demo.git'
            }
        }
        stage('Deploy') {
            steps {
                // This block connects Jenkins Credentials to Ansible Variables
                withCredentials([usernamePassword(credentialsId: "${DOCKER_CREDS_ID}", passwordVariable: 'DOCKER_PASSWORD', usernameVariable: 'DOCKER_USERNAME')]) {
                    ansiblePlaybook(
                        installation: 'ansible',
                        playbook: 'deploy.yml',
                        inventory: 'hosts.ini',
              extraVars: [
    docker_user: "${DOCKER_USERNAME}",
    docker_password: "${DOCKER_PASSWORD}" // Ansible will receive this as 'docker_password'
]
                    )
                }
            }
        }
    }
}
