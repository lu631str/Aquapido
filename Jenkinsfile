pipeline {
    agent any
    environment {
        PATH = "/usr/local/bin:/usr/bin:/bin:~/development/flutter/bin:"
    }
    stages {
        stage ("Flutter Doctor") {
            steps {
                sh "flutter doctor -v"
            }
        }
        stage ("Run Flutter Tests") {
            steps {
                sh "flutter test --update-goldens --name=Golden"
                sh "flutter test"
            }
        }
        stage('Update GIT') {
	        steps {
		        sh "git config user.email 'roland.burke@htwg-konstanz.de'"
		        sh "git config user.name 'Jenkins'"
		        sh "git add -A"
		        sh "git diff-index --quiet HEAD || git commit -m 'update goldens'"
		        sh "git push https://gitlab-ci-token:2LDK9QYHeQYzT57zGD-9@gitlab.in.htwg-konstanz.de/lehre/rschimka/mobile/g-mobile-sose21/07-mobile-sose21.git HEAD:master"
		
        	}
        }
        stage("SonarQube Analysis") {
            steps {
                sh "flutter pub get"
                sh "flutter test --machine > tests.output"
                sh "flutter test --coverage"
                script {
                    def scannerHome = tool 'SonarScanner 4.0';
                    sh "${scannerHome}/bin/sonar-scanner -X"
                }
            }
        }
        stage("Cleanup") {
            steps {
                sh "flutter clean"
            }
        }
    }
}