node("master"){
    
  environment {
        GH_TOKEN  = credentials('git-auth-token')
        NPM_TOKEN = credentials('npm_token')
    }
  stage ('Build') {
    git url: 'https://github.com/kalesujata97/npm-example.git'
    
    nodejs('node'){
    bat "npm test"
      }
  }

  stage ('Release') {
      nodejs('node'){
          bat "echo %GH_TOKEN%"
    bat "npx semantic-release"
      }
  }
}
