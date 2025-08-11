pipeline {
    agent any

    environment {
        IMAGE_NAME = "diazluthfi/nextjs-app"
        IMAGE_TAG = "v${BUILD_NUMBER}" // Tanpa 'env.' karena sudah dalam block environment
        DOCKERHUB_CREDENTIALS_ID = "a036c99f-de1f-4a66-b4fa-f19b7871d0a5"
        MARZUQ_TOKEN = "MARZUQ_TOKEN"
        MARZUQ_SERVER = "MARZUQ_SERVER"
        ADHIT_TOKEN = "ADHIT_TOKEN"
        ADHIT_SERVER = "ADHIT_SERVER"
        INDRA_TOKEN = "INDRA_TOKEN"
        INDRA_SERVER = "INDRA_SERVER"
        ADJIE_TOKEN = "ADJIE_TOKEN"
        ADJIE_SERVER = "ADJIE_SERVER"
        PARHAN_TOKEN = "PARHAN_TOKEN"
        PARHAN_SERVER = "PARHAN_SERVER"
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
                    oc apply -f nextjsnonhap.yml
                    '''
                }
                 // Deploy ke cluster INDRA
                withCredentials([
                    string(credentialsId: env.INDRA_TOKEN, variable: 'OC_TOKEN'),
                    string(credentialsId: env.INDRA_SERVER, variable: 'OC_SERVER')
                ]) {
                    sh '''
                    oc login --token=$OC_TOKEN --server=$OC_SERVER
                    oc apply -f nextjsnonhap.yml
                    '''
                }
                 // Deploy ke cluster Adjie
                withCredentials([
                    string(credentialsId: env.ADJIE_TOKEN, variable: 'OC_TOKEN'),
                    string(credentialsId: env.ADJIE_SERVER, variable: 'OC_SERVER')
                ]) {
                    sh '''
                    oc login --token=$OC_TOKEN --server=$OC_SERVER
                    oc apply -f nextjsnonhap.yml
                    '''
                }
                 // Deploy ke cluster Parhan
               withCredentials([
                        string(credentialsId: env.PARHAN_TOKEN, variable: 'OC_TOKEN'),
                        string(credentialsId: env.PARHAN_SERVER, variable: 'OC_SERVER')
                    ]) {
                        sh '''
                            echo "Login ke OpenShift..."
                            oc login --token=$OC_TOKEN --server=$OC_SERVER
                            oc project parhanzzz-20-dev

                            echo "Apply manifest..."
                            oc apply -f nextjsnonhap.yml

                            echo "Restart deployment..."
                            oc rollout restart deployment/nextjs
                            oc rollout status deployment/nextjs
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
