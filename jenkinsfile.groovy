node("master"){
    
  environment {
        GH_TOKEN  = "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"
    }
  stage ('Build') {
    git url: 'https://github.com/kalesujata97/npm-example.git'
    
    nodejs('node'){
    bat "npm test"
      }
  }

  stage ('Release') {
      nodejs('node'){
    bat "npx semantic-release"
      }
  }
}
