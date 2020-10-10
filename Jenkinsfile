pipeline {
    agent { label 'master'}
    environment {
        CONTAINER = 'gomap'
        IMAGE = 'GOMAP'
        VERSION = '1.3.2'
        ZENODO_KEY = credentials('zenodo')
    }
    
    stages {
        stage('Build') {
            steps {
                sh '''
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
    post { 
        success { 
            echo 'Documentation is successfully build'
            sh '''
                pwd
                make sync
            '''
            echo 'Documentation is successfully synced'
        }
    }
}
