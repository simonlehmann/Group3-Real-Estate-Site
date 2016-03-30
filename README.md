# PropertyDome
## :clipboard: Project Information
Please refer to te folloring links for 
* Trello Board - https://trello.com/b/9OhPluxC/real-estate-website
* Google Drive - https://drive.google.com/drive/u/0/folders/0BzjvBNtNDEyNS1p1THUyY1lnXzQ
* Slack Team - https://zapdome.slack.com

> Let me know if any of the links are broken :stuck_out_tongue_winking_eye:

## :pencil: Contributions
To work on this project, you will need to set up your local development environment. Refer to the below guides for setting up your local development environment for your platform.
> The project already has everything required to work on both Windows and Mac OS X development environments.

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
Coming soon...

### Sublime Text 3 Packages
1. Install Package Controller first, it is used to install the following
2. All Autocomplete (variable/method/function completion across all files in project folder)
3. Better CoffeeScript (syntax highlighting)
4. BracketHighlighter
5. Color Highlighter (Highlight the colour hex/rgb variables in the colour they actually are [AWESOME])
6. Emmet (look into it...... AWESOME)
7. ERB Snippets (autocompletion for ERB snippets)
8. Sass (syntax highlighting)
9. Terminal (Shortcut to open terminal in project folder)
10. ColorPicker (highlight a colour and the ```CTRL + Shift + C``` and you get a colour picker that will replace the highlighted value with a hex colour value you selected...... AWESOME)

## :computer: Server Information
During the development of the application, it will be hosted on the Web24 VPS provided by Central Institute of Technology. 
> :key: Login details will be provided here...

This server will have the following capabilities:
* Web Server (to host the application)
* MySQL Server (to host the applications database)
* Mail Server (to send emails from the bought-and-payed-for domain e.g no-reply@propertydome.com)

## :checkered_flag: Now let's win this thing! :trophy:
