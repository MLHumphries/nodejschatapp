pipeline 
{
    agent none
    stages 
    {
        stage('CLONE GIT REPOSITORY') 
        {
            agent 
            {
                label 'appserver_softsec'
            }
            steps 
            {
                checkout scm
            }
        }  
 
        stage('SCA-SAST-SNYK') 
        {
            agent any
            steps 
            {
                script 
                {
                    catchError(buildResult: 'SUCCESS', stageResult: 'SUCCESS')
                    {
                        snykSecurity(snykInstallation: 'Snyk', snykTokenId: 'snyk_credentials', severity: 'high')
                    }
                    
                }
            }
        }
 
        stage('SonarQube Analysis') 
        {
            agent 
            {
                label 'appserver_softsec'
            }
            steps 
            {
                script 
                {
                    def scannerHome = tool 'sonarqube'
                    withSonarQubeEnv('sonarqube') 
                    {
                        sh "${scannerHome}/bin/sonar-scanner \
                            -Dsonar.projectKey=chat-application \
                            -Dsonar.sources=."
                    }
                }
            }
        }
 
        stage('BUILD-AND-TAG') 
        {
            agent 
            {
                label 'appserver_softsec'
            }
            steps 
            {
                script 
                {
                    def app = docker.build("mlhumphries/nodejschatapp")
                    app.tag("latest")
                }
            }
        }
 
        stage('POST-TO-DOCKERHUB') 
        {    
            agent 
            {
                label 'appserver_softsec'
            }
            steps {
                script 
                {
                    docker.withRegistry('https://registry.hub.docker.com', 'dockerhub_credentials') 
                    {
                        def app = docker.image("mlhumphries/nodejschatapp")
                        app.push("latest")
                    }
                }
            }
        }
 
        stage('DEPLOYMENT') 
        {    
            agent 
            {
                label 'appserver_softsec'
            }
            steps 
            {
                sh "docker-compose down"
                sh "docker-compose up -d"   
            }
        }
    }
}