pipeline {
    agent { label 'master'}
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
                    mkdir tmp
                    singularity exec /mnt/${CONTAINER}/${IMAGE}/${VERSION}/${IMAGE}.sif pwd
                '''
            }
        }
        stage('Test') {
            steps {
                echo 'Testing..'
                sh '''
                    echo ./test.sh
                '''
            }
        } 
    }
    post { 
        success { 
            echo 'GOMAP image is successfully tested'
            sh '''
                imkdir -p /iplant/home/shared/dillpicl/${CONTAINER}/${IMAGE}/${VERSION}/ && \
                ichmod -r read anonymous /iplant/home/shared/dillpicl/${CONTAINER} && \
                icd /iplant/home/shared/dillpicl/${CONTAINER}/${IMAGE}/${VERSION}/ && \
                irsync -sVN 1 /mnt/${CONTAINER}/${IMAGE}/${VERSION}/${IMAGE}.sif i:${IMAGE}.sif && \
                ichmod read anonymous ${IMAGE}.sif
                cd docs
                virtualenv -p python3 venv
                . venv/bin/activate
                pip install -r requirements.txt 
                make clean
                make build
            '''
        }
    }
}
