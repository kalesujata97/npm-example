node("master"){
  stage ('Build') {
 
    git credentialsId: 'ea4c3770-b2ed-4639-9ffc-cc3e586e454c', url: 'https://github.com/kalesujata97/npm-example.git'
    bat "npm test"
  }
}
