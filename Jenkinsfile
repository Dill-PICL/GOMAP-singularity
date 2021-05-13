pipeline {
    agent { label 'master'}
    environment {
        CONTAINER = 'gomap'
        IMAGE = 'GOMAP'
        VERSION = 'v1.3.5'
    }
    stages {
        stage('Build') {
            when { 
                anyOf {
                    changeset "docs/*"
                    changeset "Jenkinsfile"
                }
                anyOf {
                    branch 'master'
                }
            }
            steps {
                echo 'Building the documents'
                sh '''
                    git fetch
                    echo ${FILECHECK}
                    cd docs
                    virtualenv -p python3 venv
                    . venv/bin/activate
                    pip install -r requirements.txt 
                    make clean
                    make buildmult
                    '''
            }
        }
         stage('Push Artifacts') {
              when { 
                anyOf {
                    changeset "docs/*"
                    changeset "Jenkinsfile"
                }
                anyOf {
                    branch 'master'
                }
            }
            steps{
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
    post { 
        success { 
            echo 'Documentation is successfully built and synced'
        }
    }
}