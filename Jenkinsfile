pipeline {
    agent any

    environment {
        DOCKER_IMAGE = "diazluthfi/nextjs-app:${env.BUILD_NUMBER}"
        DOCKER_LATEST_IMAGE = "diazluthfi/nextjs-app:latest"
        PROJECT_DIR = "nextjs-app"
        MANIFEST_DIR = "manifests"
        DEPLOYMENT_FILE = "${MANIFEST_DIR}/deployment.yaml"
    }

    stages {
        stage('Checkout') {
            steps {
                git branch: 'main', url: 'https://github.com/diazluthfi/nextjs-cicd.git'
            }
        }

        stage('Build Docker Image') {
            steps {
                sh "docker build -t ${DOCKER_IMAGE} -t ${DOCKER_LATEST_IMAGE} ."
            }
        }

        stage('Push Docker Image') {
            steps {
                withCredentials([usernamePassword(credentialsId: 'docker-hub', usernameVariable: 'DOCKER_USER', passwordVariable: 'DOCKER_PASS')]) {
                    sh '''
                        echo "$DOCKER_PASS" | docker login -u "$DOCKER_USER" --password-stdin
                        docker push ${DOCKER_IMAGE}
                        docker push ${DOCKER_LATEST_IMAGE}
                        docker logout
                    '''
                }
            }
        }

        // stage('Update Manifest') {
        //     steps {
        //         sh """
        //             sed -i 's|image: .*|image: ${DOCKER_IMAGE}|' ${DEPLOYMENT_FILE}
        //         """
        //     }
        // }

        // stage('Deploy to OpenShift') {
        //     steps {
        //         sh "oc apply -f ${MANIFEST_DIR}/"
        //     }
        // }
    }

    post {
        success {
            echo "✅ CI/CD Next.js completed successfully."
        }
        failure {
            echo "❌ CI/CD pipeline failed."
        }
    }
}
