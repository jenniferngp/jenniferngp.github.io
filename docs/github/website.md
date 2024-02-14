---
layout: default
parent: "2. Github 🔀"
permalink: /doc/github/website
nav_order: 2
title: 2.1 Build a website (Jekyll)
---

# Build a website with Jekyll template

1. Create a GitHub repository
2. Clone repository to local
```sh
git clone https://github.com/your-username/respository-name.git
```
3. Install Ruby  
To check if you have Ruby installed, run
```sh
ruby -v
```
If not, refer to the Ruby documentation for instructions (https://www.ruby-lang.org). 
4. Install Bundler
```sh
gem install bundler
```
5. Set up Just the Docs template
```sh
cd repository-name
```
Create a file named "Gemfile" and add the following lines
```sh
source "https://rubygems.org"
gem "github-pages", group: :jekyll_plugins
```
Save and close "Gemfile".  
Then, create a file named "_config.yml" and add the following lines
```sh
remote_theme: pmarsceill/just-the-docs
title: My Docs
description: Your site description
```
Save and close “_config.yml”.
6. Install webrick  
```sh
gem install webrick
```
If you have Ruby 3.0, you'll need to add to Gemfile because it's no longer provided.
```sh
bundle add webrick
```
6. Install the required dependencies
```sh
bundle install
```
7. Build and serve website
```sh
bundle exec jekyll serve
```
Jekyll will start the local server and output a URL where you can view your website real-time.  
Open your web browser and visit the provided URL. 


