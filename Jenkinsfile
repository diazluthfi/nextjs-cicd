pipeline {
    agent {
        kubernetes {
            yaml """
apiVersion: v1
kind: Pod
spec:
  containers:
  - name: kaniko
    image: gcr.io/kaniko-project/executor:latest
    command:
    - cat
    tty: true
    volumeMounts:
    - name: docker-config
      mountPath: /kaniko/.docker
  volumes:
  - name: docker-config
    secret:
      secretName: dockerhub-config
"""
        }
    }
    environment {
        IMAGE_NAME = "diazluthfi/nextjs-app"
        IMAGE_TAG = "v${env.BUILD_NUMBER}"
    }
    stages {
        stage('Build and Push with Kaniko') {
            steps {
                container('kaniko') {
                    sh """
                    /kaniko/executor \
                      --context `pwd` \
                      --dockerfile `pwd`/Dockerfile \
                      --destination=${IMAGE_NAME}:${IMAGE_TAG} \
                      --destination=${IMAGE_NAME}:latest
                    """
                }
            }
        }
    }
    post {
        failure {
            echo "❌ CI/CD pipeline failed."
        }
        success {
            echo "✅ CI/CD pipeline success."
        }
    }
}
