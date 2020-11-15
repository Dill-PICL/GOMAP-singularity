pipeline {
    agent { label 'master'}
    environment {
        CONTAINER = 'gomap'
        IMAGE = 'GOMAP'
        VERSION = '1.3.2'
        testFile = new File("/mnt/gomap/GOMAP/1.3.2/GOMAP.sif")
        FILECHECK = testFile.exists()
    }
    stages {
        stage('Build') {
            steps {
                sh '''
                    echo ${FILECHECK}
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
                cd docs
                pwd
                ls
                make syncDocs
            '''
            echo 'Documentation is successfully synced'
        }
    }
}
