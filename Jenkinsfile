pipeline {
    agent { label 'master'}
    environment {
        CONTAINER = 'gomap'
        IMAGE = 'GOMAP'
        VERSION = '1.3.3'
    }
    
    stages {
        stage('Build') {
            steps {
                when { 
                anyOf {
                    changeset "docs/*"
                }
                anyof{
                    branch 'master'
                    branch 'dev'
                }
            }
                sh '''
                    cd docs
                    virtualenv -p python3 venv
                    . venv/bin/activate
                    pip install -r requirements.txt 
                    make clean
                    make build -D version=${VERSION} -D release=${VERSION}
                '''
            }
        }
    }
    post { 
        success { 
            echo 'Documentation is successfully build'
            sh '''
                cd docs
                pwd
                ls
                make syncDocs
            '''
            echo 'Documentation is successfully synced'
        }
    }
}
