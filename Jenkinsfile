pipeline {
    agent any

    parameters {
        string(name: 'IMAGE_NAME', defaultValue: 'app', description: 'The name of my docker image')
        string(name: 'IMAGE_TAG', defaultValue: 'latest', description: 'The tag of my docker image')
        string(name: 'CONTAINER_NAME', defaultValue: 'app-container', description: 'The name of my docker image')
        string(name: 'DOCKER_HUB_ID', defaultValue: 'franklinfoko', description: 'The docker hub username')
        string(name: 'ECR_REPO_NAME', defaultValue: 'demoecr', description: 'The docker hub username')
    }

    stages {
        stage('Checkout') {
            steps {
                echo 'Checkout..'
                checkout scm
            }
        }
        
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
                        CONTAINER_IP=$(docker inspect -f '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' "$CONTAINER_NAME")
                        echo "$CONTAINER_IP"
                        curl -i http://$CONTAINER_IP:8000
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
        stage('Push Image on ECR') {
            steps {
                echo 'Pushing..'
                // docker.withRegistry(
                //     "https://891377281461.dkr.ecr.ca-central-1.amazonaws.com", "ecr:ca-central-1:aws-credentials") {
                //     docker.image(${IMAGE_NAME}:${IMAGE_TAG}).push()
                // }
                withCredentials([aws(
                    accessKeyVariable: 'AWS_ACCESS_KEY_ID', 
                    credentialsId: 'aws-credentials', 
                    secretKeyVariable: 'AWS_SECRET_ACCESS_KEY')]) 
                    {
                     sh '''
                        aws ecr get-login-password --region ca-central-1 | docker login --username AWS --password-stdin 891377281461.dkr.ecr.ca-central-1.amazonaws.com
                        docker tag ${IMAGE_NAME}:${IMAGE_TAG} 891377281461.dkr.ecr.ca-central-1.amazonaws.com/${ECR_REPO_NAME}:${IMAGE_TAG}
                        docker push 891377281461.dkr.ecr.ca-central-1.amazonaws.com/${ECR_REPO_NAME}:${IMAGE_TAG}
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