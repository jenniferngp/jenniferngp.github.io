---
layout: default
title: 2.0 Setting up GitHub
parent: "2. Github 🔀"
nav_order: 1
permalink: /docs/gibhut/setup
---

# What is Github?

GitHub is a web-based platform used for version control and collaboration on software projects. It provides developers with a centralized location to store, manage, and track changes to their code. GitHub utilizes the Git version control system, which allows multiple people to work on the same codebase simultaneously while keeping track of changes and facilitating collaboration. 

# Set up Git

1. Download

2. Configure name and email for identification
```sh 
git config --global user.name "Your name"
git config --global user.email "your@email.com"
```

3. Initialize repository
```sh
git Initialize
ls -a # check if there is a .git
```
4. Check status
Check if there are untracked files or staged files that need to be added to repo
```sh
git status
```

5. Stage files
```sh
git add filename1 filename2
```

6. Making commits
```sh
git commit -m "Commit message"
```

7. Check history of commit
```sh
git log
```
8. Push
```sh
git push -u origin main
```

