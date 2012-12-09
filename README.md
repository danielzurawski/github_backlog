#Github backlog

Hey ! Here is a little project I've done just to try rails again :)

Basically it's a github-backlog. You can create some user stories, and then work on them. Oh and your issues are automatically linked to your user stories using the [GB #STORY_NUMBER]

##How to install ?

Easy.

```
git clone https://github.com/scboffspring/github_backlog.git
```

Then you need to create a developer app on github
https://github.com/settings/applications

Once it is done, edit the files config/initializers/omniauth.rb with the info you got from github.

Then simple tasks as :
```
rake db:create
rake db:migrate

rails server
```

Job done, your server is started (http://localhost:3000) and you can login using github :)

##Fork it

You can fork it if you want. And do whatever you want with the code

##No test?

Yeah sorry.. I totally know that this is bad, but anyway.. It's not done, that's it.