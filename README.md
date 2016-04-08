# PropertyDome
## :clipboard: Project Information
Please refer to the folloring links for any project information:
* Trello Board - https://trello.com/b/9OhPluxC/real-estate-website
* Google Drive - https://drive.google.com/drive/u/0/folders/0BzjvBNtNDEyNS1p1THUyY1lnXzQ
* Slack Team - https://zapdome.slack.com

> Let me know if any of the links are broken :stuck_out_tongue_winking_eye:

## :pencil: Contributions
To work on this project, you will need to set up your local development environment. Refer to the below guides for setting up your local development environment for your platform.
> The project already has everything required to work on both Windows and Mac OS X development environments.

## Get Repository
To get this repository into a local directory you'll need to do the following
* Create a project folder
* cd into this folder using your terminal i.e ```cd /path/to/project/folder```
* Type ```git init```
* Type ```git remote add origin https://github.com/slehmann36/Group3-Real-Estate-Site.git```
* To pull the branch you want to work on type ```git pull origin branch`` replacing <branch> with the branch tag (like feature1)
* Work on feature branch then if you want to commit your changes type ```git add .``` or ```git add --all``` (NB. type ```git status``` to see what changes you need to track)
* Once they're added type ```git commit -m "Enter your commit message here"```
* To push to your branch you enter ```git push origin branch```

Try and limit the work you do on the master branch, all development should be done on a branch you created for your feature. These can be created on the web easier than via command line)

Get into the habit of pulling before you do any work on your branch, incase someone has committed to it beforehand.

> Note, to run the server you'll need to run ```bundle install``` first on your local machine.

### Coding Standards
Please make every effort to ensure that any code submitted to this repository follows the coding standards as set out in the document linked below.
> [Project Coding Standards] (https://drive.google.com/open?id=18F52kEOdb0eG1TtQPi_kskgJIjToppe2-23_J8VWmzw "Coding Standards")

### Windows
#### Installing Sublime Text 3
Install Sublime Text editor from http://www.sublimetext.com/3. Select the *Windows* (non-64-bit) to download the installer.
#### Installing Ruby
Install Ruby from http://rubyinstaller.org/. Click the huge red *Download* button
#### Installing Rails
Test to see if it’s already installed:
From cmd line:
```{r, engine='bash', count_lines}
rails –v
```
If it comes back with a version, it’s installed.
If not follow below:
From cmd line:
```{r, engine='bash', count_lines}
gem install rails
```
This will install all the rails gems and components.
When finished, type:
```{r, engine='bash', count_lines}
rails –v
```
It should now come back with Rails 4.2.5 (or similar)
Check what gem version you have installed:
```{r, engine='bash', count_lines}
gem –v
```
Should return: 2.0.14.1 (or similar)
Now display a list of gems already installed:
```{r, engine='bash', count_lines}
gem list
```
This will list all the gems that came down as default as well as your rails gems.

### Mac OS X
#### Installing Sublime Text 3
Install Sublime Text editor from http://www.sublimetext.com/3. Select *OS X* to download the installer.
#### Installing Ruby, Rails, Git, RVM
Follow the guide at http://installrails.com/ for a step by step guide for installing Rails, Ruby, Homebrew and Git.

You can confirm the install using the same commands as for windows in your terminal (although the guide guides you through it).

### Sublime Text 3 Packages
1. Install Package Controller first, it is used to install the following
2. All Autocomplete (variable/method/function completion across all files in project folder)
3. Better CoffeeScript (syntax highlighting)
4. BracketHighlighter
5. Color Highlighter (Highlight the colour hex/rgb variables in the colour they actually are [AWESOME])
6. Emmet (look into it...... AWESOME)
7. ERB Snippets (autocompletion for ERB snippets, Jayden has created his own additional Snippets for this package they can be found [here](https://drive.google.com/open?id=0B6E7GLA3svEcTnJqTWwyOXc5RDA "Custom ERB Snippets"))
8. Sass (syntax highlighting)
9. Terminal (Shortcut to open terminal in project folder, see Daniel/Jayden for configuration tips for use in class)
10. ColorPicker (highlight a colour and the ```CTRL + Shift + C``` and you get a colour picker that will replace the highlighted value with a hex colour value you selected...... AWESOME)

## :computer: Server Information
During the development of the application, it will be hosted on ~~the Web24 VPS provided by Central Institute of Technology~~ Simon's infrustructure. 
###:key: Login Details
#### Application Access
URL: ```db.slehmann36.com```  
Username: ```pdappuser```  
Password: ```MhalliF123...```  
Require SSL ```True```

####PhpMyAdmin
URL: ```https://db.slehmann36.com/phpmyadmin/```  
Username: ```admin```  
Password: ```MhalliF123```

:exclamation:Don't you bastards break my server!

This server will have the following capabilities:
* Web Server (to host the application)
* MySQL Server (to host the applications database)
* Mail Server (to send emails from the bought-and-payed-for domain e.g no-reply@propertydome.com)

## :checkered_flag: Now let's win this thing! :trophy:
