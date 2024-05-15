
pipeline {
    agent any
    tools {
        nodejs "node"
    }
    stages {
        stage("increment version") {
            steps {
                script {
                    echo "incrementing app version..."
                    dir("app") {
                        sh "npm version minor"
                        def packageJson = readJSON file: "package.json"
                        def version = packageJson.version
                        env.IMAGE_NAME = "$version-$BUILD_NUMBER"
                    }
                }
            }
        }
        stage("run tests") {
            steps {
                script {
                    echo "running tests..."
                    dir("app") {
                        sh "npm install"
                        sh "npm run test"
                    }
                }
            }
        }
        stage("build and push docker image") {
            steps {
                script {
                    withCredentials([usernamePassword(credentialsId: 'dockerhub-creds', passwordVariable: 'PASS', usernameVariable: 'USER')]) {
                    sh "docker build -t sumanrizvi/jenkins-exercises:${IMAGE_NAME} ."
                    sh 'echo $PASS | docker login -u $USER --password-stdin'
                    sh "docker push sumanrizvi/jenkins-exercises:${IMAGE_NAME}"
                    }
                }
            }
        }
        stage("commit version udpate") {
            steps {
                script {
                    withCredentials([string(credentialsId: "github-auth-token", variable: "TOKEN")]) {
                        sh 'git config --global user.email "sumanrizvi@gmail.com"'
                        sh 'git config --global user.name "Sumanrizvi"'
                        sh "git remote set-url origin https://github.com/Sumanrizvi/jenkins-exercises.git"
                        sh 'git add .'
                        sh 'git commit -m "ci: version bump"'
                        sh 'git push origin HEAD'
                    }
                }
            }
        }
    }
}