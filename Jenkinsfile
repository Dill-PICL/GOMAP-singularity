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
                    azcopy cp https://gomap.blob.core.windows.net/gomap/${IMAGE}/${VERSION}/${IMAGE}.sif > GOMAP-base.sif && \
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
        stage('Post') {
            steps {
                echo 'Image Successfully Built'
                sh '''
                    python3 zenodo_upload.py ${ZENODO_KEY}
                '''
            }
        }
    }
}