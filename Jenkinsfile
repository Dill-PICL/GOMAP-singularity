pipeline {
    agent { label 'master'}
    environment {
        CONTAINER = 'gomap'
        IMAGE = 'GOMAP'
        VERSION = '1.3.3'
    }
    stages {
        stage('Build') {
            when { 
                anyOf {
                    changeset "docs/*"
                    changeset "Jenkinsfile"
                }
                anyOf {
                    checkImageLoc() == 'true'
                }
                anyOf {
                    branch 'master'
                }
            }
            steps {
                echo 'Building the documents'
                sh '''
                    echo ${FILECHECK}
                    cd docs
                    virtualenv -p python3 venv
                    . venv/bin/activate
                    pip install -r requirements.txt 
                    make clean
                    make build version=${VERSION} release=${VERSION}
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
                anyOf {
                    checkImageLoc() == 'true'
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

def checkImageLoc(){
    def filePath = "/mnt/gomap/GOMAP/1.3.2/GOMAP.sif"
    def file = new File(filePath)
    return file.exists()
}