pipeline {
    agent { label 'ubuntu'}
    environment {
        CONTAINER = 'gomap'
        IMAGE = 'GOMAP'
        VERSION = '1.3.1'
        ZENODO_KEY = credentials('zenodo')
    }
    
    stages {
        stage('Build') {
            steps {
                sh '''
                    singularity --version && \
                    ls -lah && \
                    mkdir tmp && \
                    azcopy cp https://gomap.blob.core.windows.net/gomap/${IMAGE}/${VERSION}/${IMAGE}.sif > GOMAP.sif
                '''
            }
        }
        stage('Test') {
            steps {
                echo 'Testing..'
                sh '''
                    ./test.sh
                '''
            }
        } 
        stage("Post"){
            agent 
        }       
    }
    post { 
        success { 
            echo 'GOMAP image is successful'
            sh '''
                python3 zenodo_upload.py ${ZENODO_KEY} 
            '''
        }
    }
}
