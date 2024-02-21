---
layout: default
parent: "1. Bioinformatics Tutorials 🧬"
permalink: /doc/bioinformatics/git
nav_order: 9
title: 1.9 Git
---

# Git

0. Make the repository public
1. Fork repo into your private account
2. Generate a fine-grained token so you can upload files into that repo that is now yours from the server
- Click on your profile icon (top right)
- Go to settings
- Select "Developer Settings" on the left navigation bar
- Select "Personal access tokens"
- Select "Fine-grained tokens"
- Select "Generate new token". Complete the form. Under "Repository access", I selected "Only select repositories". Under "Repository permissions", make sure you enable "Read and Write" access for "Actions", "Administration", "Commit statuses", "Contents", "Pull requests", "Deployments" (I think optional). 
- Once your token is generated, save the password to a different location. You will not see it again
3. On the terminal, git clone the forked repo 
4. Add/edit any files 
5. To upload changes, create a new branch
```sh
git checkout -b new-branch # creates a new branch "new-branch"
git branch # checkes which branch you're in
```
6. Stage files
```sh
git status # check what changes have been made
git add . # add the changes
git status # check that the changes have been staged and ready to commit
```
7. Commit with a detailed message
```sh
git commit -m "message" 
git status # should be "nothing to commit, working directory clean"
```
9. Push changes 
```sh
git push origin new-branch
```
You will then be prompted to enter your github username and the token password (the one you generated in step 2). 

10. On the brower, go to the forked repo in your account. 
11. Select "Compare & pull request", then "Create pull request".
12. Since you are the manager of the original repo, the page will take you to the original repo page and ask if you want to merge the pull request. If yes, select "Merge pull request", then "Confirm merge", then "Delete branch". 
12. Update the repo on your terminal
```sh
git pull origin main
```
13. Go to your forked repo and select "Sync fork"
14. Done! 
