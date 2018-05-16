pipeline {
  agent any

  environment {
    JOB_DESC = 'example_mail'
    PIPELINE = "https://jenkins.example.com/blue/organizations/jenkins/${env.JOB_DESC}/detail/${env.JOB_BASE_NAME}/${env.BUILD_NUMBER}/pipeline"
  }

  options {
    disableConcurrentBuilds()
    timestamps()
    timeout(time: 5, unit: 'MINUTES')
  }

  stages {

    // notify slack of build-number, job and branch
    stage('notify') {
      steps {
        sh 'echo $BRANCH_NAME'
        slackSend(color: '#0F1DBC', message: "[${env.BUILD_NUMBER}] *STARTED:* Job `${env.JOB_DESC}` Branch `${env.GIT_BRANCH}` ( <${env.BUILD_URL}|Open> ) - ( <${env.PIPELINE}|BlueOcean> )")
      }
    }

    // pre-converge stage
    stage('pre-converge') {
      steps {
        echo 'rubocop style linting'
        sh '''
          eval "$(chef shell-init bash)"
          rubocop
        '''
        echo 'foodcritic compliance testing'
        sh '''
          eval "$(chef shell-init bash)"
          foodcritic .
        '''
        echo 'rspec unit testing'
        echo 'TODO: implement rspec unit-testing'
        // sh '''
        //   eval "$(chef shell-init bash)"
        //   rspec
        // '''
      }
    }

    // converge stage
    stage('converge') {
      steps {
        echo 'kitchen converge cookbook'
      }
    }

    // post-converge stage
    stage('post-converge') {
      steps {
        echo 'do integration testing with the machine'
      }
    }

    // archive pipeline results
    stage('archive results') {
      steps {
        echo 'archive artefacts to somewhere'
      }
    }
  }

  // post-build actions - cleanup, notify and document
  post {

    // Always runs. And it runs before any of the other post conditions.
    always {
      echo 'report on rspec findings'
      echo 'TODO: unit-tests'
      // junit 'results.xml'
      echo 'wipe out the workspace before finish'
      // deleteDir()
    }

    success {
      echo 'TODO: notify JIRA / Confluence for comments on the build of the issue'
      slackSend(color: '#00FF3B', message: "[${env.BUILD_NUMBER}] *SUCCESS:* Job `${env.JOB_DESC}` Branch `${env.GIT_BRANCH}` ( <${env.BUILD_URL}|Open> ) - ( <${env.PIPELINE}|BlueOcean> )")
    }

    failure {
      echo 'TODO: notify JIRA / Confluence for comments on the build of the issue'
      slackSend(color: '#FF0000', message: "[${env.BUILD_NUMBER}] *FAILED:*  Job `${env.JOB_DESC}` Branch `${env.GIT_BRANCH}` ( <${env.BUILD_URL}|Open> ) - ( <${env.PIPELINE}|BlueOcean> )")
    }
  }
}
