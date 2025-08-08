pipeline {
    agent any

    environment {
        OPENSHIFT_API = 'https://api.rm1.0a51.p1.openshiftapps.com:6443/apis/user.openshift.io/v1/users/~'
        TOKEN = credentials('sha256~kGmckFiAYRGDhEcSjgFB7D7QtNlmcpD-P4k-Tg1ZGfI')
        NAMESPACE = 'myproject'
        
    }

    stages {
        stage('Clone Git Repo') {
            steps {
                git branch: 'main', url: 'https://github.com/diazluthfi/nextjs-cicd.git'
            }
        }

        stage('Login to OpenShift') {
            steps {
                sh 'oc login --token=$TOKEN --server=$OPENSHIFT_API'
            }
        }

        stage('Apply Config to OpenShift') {
            steps {
                sh '''
                oc project $NAMESPACE
                oc apply -f config/configmap.yaml
                '''
            }
        }
    }
}