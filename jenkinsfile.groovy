node("master"){
  stage ('Build') {
 
    git url: 'https://github.com/kalesujata97/npm-example.git'
    bat "npm test"
  }

  stage ('Release') {
    bat "npm run semantic-release"
  }
}
