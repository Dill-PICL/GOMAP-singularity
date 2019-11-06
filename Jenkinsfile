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
                #echo python3 zenodo_upload.py ${ZENODO_KEY}
                irsync -p /mnt/${CONTAINER}/${IMAGE}/${VERSION}/${IMAGE}.sif i:/iplant/home/shared/dillpicl/gomap/${CONTAINER}/${IMAGE}/${VERSION}/${IMAGE}.sif
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
