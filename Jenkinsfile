
pipeline {
    agent any
    tools {
        nodejs "my-nodejs"
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
                    withCredentials([usernamePassword(credentialsId: 'docker-hub-repo', passwordVariable: 'PASS', usernameVariable: 'USER')]) {
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
                    withCredentials([usernamePassword(credentialsId: "github-creds", usernameVariable: "USER", passwordVariable: "PASS")]) {
                        sh 'git config --global user.email "jenkins@example.com"'
                        sh 'git config --global user.name "jenkins"'
                        sh 'git remote set-url origin https://$USER:$PASS@https://github.com/Sumanrizvi/jenkins-exercises.git'
                        sh 'git add .'
                        sh 'git commit -m "ci: version bump"'
                        sh 'git push origin HEAD:jenkins-jobs'
                    }
                }
            }
        }
    }
}