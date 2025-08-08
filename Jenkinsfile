pipeline {
    agent any

    environment {
        IMAGE_NAME = "diazluthfi/nextjs-app"
        IMAGE_TAG = "v${BUILD_NUMBER}" // Tanpa 'env.' karena sudah dalam block environment
        DOCKERHUB_CREDENTIALS_ID = "a036c99f-de1f-4a66-b4fa-f19b7871d0a5"
        TOKEN_CREDENTIALS_ID = "024936f6-e9a4-42aa-839f-da9984b2a089"
        SERVER_CREDENTIALS_ID = "1a856ca8-927b-4627-bc5c-eeefb94cd1d1"
        
        OPENSHIFT_NAMESPACE = "cicdnextjs" // ganti dengan project-mu
        MANIFEST_PATH = "nextjs.yaml"  
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

    
        stage('Deploy to OpenShift') {
            steps {
                withCredentials([string(credentialsId: TOKEN_CREDENTIALS_ID, variable: 'OC_TOKEN')]) {
                    sh '''
                    oc login --token=$OC_TOKEN --server=https://api.rm1.0a51.p1.openshiftapps.com:6443
                    oc apply -f manifest.yaml
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
