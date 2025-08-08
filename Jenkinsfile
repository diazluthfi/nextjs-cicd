pipeline {
    agent any

    tools {
        nodejs "node20"
    }

    stages {
        stage('Clone') {
            steps {
                git branch: 'main', url: 'https://github.com/diazluthfi/nextjs-cicd.git'
            }
        }

        stage('Install') {
            steps {
                sh 'npm install'
            }
        }

        stage('Build') {
            steps {
                sh 'npm run build'
            }
        }

        stage('Test') {
            steps {
                sh 'npm start'
            }
        }
    }
}
