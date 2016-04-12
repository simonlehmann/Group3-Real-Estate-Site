# Created by Erdal Erkilic
# 13/4/16
# This is all javascript realated to the contact page


$('.ui.form')
  .form({
    name: {
      identifier  : 'name',
      rules: [
        {
          type   : 'empty',
          prompt : 'Please enter your name'
        }
      ]
    }
    });