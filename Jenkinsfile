pipeline {
    agent any

    parameters {
        string(name: 'IMAGE_NAME', defaultValue: 'app', description: 'The name of my docker image')
        string(name: 'IMAGE_TAG', defaultValue: 'latest', description: 'The tag of my docker image')
    }

    stages {
        stage('Build Image') {
            steps {
                echo 'Building..'
                script {
                    sh 'docker build -t ${IMAGE_NAME}:${IMAGE_TAG} .'
                }
            }
        }
        stage('Test Image') {
            steps {
                echo 'Testing..'
                script {
                    sh '''
                        docker run -d -p 80:8000 --name ${CONTAINER_NAME} ${IMAGE_NAME}:${IMAGE_TAG}
                        sleep 5
                        docker logs ${CONTAINER_NAME}
                        docker rm -f ${CONTAINER_NAME}
                        docker tag ${IMAGE_NAME}:${IMAGE_TAG} ${DOCKER_HUB_ID}/${IMAGE_NAME}:${IMAGE_TAG}
                    '''
                }
            }
        }
        stage('Push Image on docker hub') {
            steps {
                echo 'Pushing..'
                withCredentials([usernamePassword(
                    credentialsId: 'docker-hub-cred', 
                    passwordVariable: 'DOCKERHUB_PASSWORD', 
                    usernameVariable: 'DOCKERHUB_USER')]) {
                    sh '''
                        docker login -u $DOCKERHUB_USER -p $DOCKERHUB_PASSWORD
                        docker push ${DOCKER_HUB_ID}/${IMAGE_NAME}:${IMAGE_TAG}
                    '''
                }
            }
        }
        stage('Deploy') {
            steps {
                echo 'Deploying....'
            }
        }
    }
}