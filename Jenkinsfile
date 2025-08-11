pipeline {
    agent any

    environment {
        IMAGE_NAME = "diazluthfi/nextjs-app"
        IMAGE_TAG = "v${BUILD_NUMBER}" // Tanpa 'env.' karena sudah dalam block environment
        DOCKERHUB_CREDENTIALS_ID = "a036c99f-de1f-4a66-b4fa-f19b7871d0a5"
        MARZUQ_TOKEN = "6fd7c47e-ffd7-4b2b-907b-436d6a327c8c"
        MARZUQ_SERVER = "1a856ca8-927b-4627-bc5c-eeefb94cd1d1"
        ADHIT_TOKEN = "1971f6af-4364-4520-b6d3-7a06462967bd"
        ADHIT_SERVER = "982385ef-d60e-4b8f-aedc-aa77ad6ff0e3"
        INDRA_TOKEN = "5e05a171-1bbd-456e-9ac5-61bf0c4e1e5d"
        ADJIE_TOKEN = "39061b16-9b3c-4837-aa45-a3fe74ae3d7f"
        OPENSHIFT_NAMESPACE = "cicdnextjs" 
        MANIFEST_PATH = "nextjs.yml"  
    }

    stages {
        stage('Checkout Code') {
            steps {
                checkout scm
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    sh """
                    docker build -t ${IMAGE_NAME}:${IMAGE_TAG} .
                    docker tag ${IMAGE_NAME}:${IMAGE_TAG} ${IMAGE_NAME}:latest
                    """
                }
            }
        }

        stage('Login to Docker Hub') {
            steps {
                withCredentials([usernamePassword(
                    credentialsId: DOCKERHUB_CREDENTIALS_ID,
                    usernameVariable: 'DOCKER_USER',
                    passwordVariable: 'DOCKER_PASS'
                )]) {
                    sh 'echo $DOCKER_PASS | docker login -u $DOCKER_USER --password-stdin'
                }
            }
        }

        stage('Push to Docker Hub') {
            steps {
                sh """
                docker push ${IMAGE_NAME}:${IMAGE_TAG}
                docker push ${IMAGE_NAME}:latest
                """
            }
        }

        stage('Update YAML with Latest Tag') {
            steps {
                script {
                    sh """
                    sed -i 's|__IMAGE_TAG__|${IMAGE_TAG}|' ${MANIFEST_PATH}
                    """
                    echo "✅ Placeholder __IMAGE_TAG__ berhasil diganti dengan tag: ${IMAGE_TAG}"
                    sh "grep 'image:' ${MANIFEST_PATH}"
                }
            }
        }

        stage('Deploy to OpenShift') {
    steps {
        // Deploy ke cluster Marzuq
        withCredentials([
            string(credentialsId: env.MARZUQ_TOKEN, variable: 'OC_TOKEN'),
            string(credentialsId: env.MARZUQ_SERVER, variable: 'OC_SERVER')
        ]) {
            sh '''
            oc login --token=$OC_TOKEN --server=$OC_SERVER
            oc apply -f nextjs.yml
            '''
        }

        // Deploy ke cluster Adhit
        withCredentials([
            string(credentialsId: env.ADHIT_TOKEN, variable: 'OC_TOKEN'),
            string(credentialsId: env.ADHIT_SERVER, variable: 'OC_SERVER')
        ]) {
            sh '''
            oc login --token=$OC_TOKEN --server=$OC_SERVER
            oc apply -f nextjs.yml
            '''
        }
    }
    }
    }

                

    
    

    post {
        success {
            echo "✅ Image successfully pushed to Docker Hub as ${IMAGE_NAME}:${IMAGE_TAG}"
        }
        failure {
            echo "❌ Build or push failed!"
        }
    }
}
