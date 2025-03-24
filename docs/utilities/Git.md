frequently used commands
`git fetch origin staging
`git reset --hard origin/staging


**gerrit 101**

Each commit creates a new patch, so it’s necessary to update the current commit for new changes
`git commit -m "Add feature XXX"
`git commit --amend --no-edit
`git push origin HEAD:refs/for/master

Get and checkout to specify commit message
`git fetch origin 6937df5b42b2b0b9d56603cc95c28f5410b7adf6
`git checkout 6937df5b42b2b0b9d56603cc95c28f5410b7adf6