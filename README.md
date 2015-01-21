# paperclip-keeponvalidation

Here we have an example of how to use paperclip and when validatin your form, if any validation errors occurs, you files will be keep on form. Without that, your use will have to upload all files again.

# Single File

First configure your base class ActiveRecord to have shared methods:
* https://github.com/mariohmol/paperclip-keeponvalidation/blob/master/config/initializers/active_record.rb#L4

Include in your model, in the example here user, hidden field and a method to update file when it looses.

* https://github.com/mariohmol/paperclip-keeponvalidation/blob/master/app/models/user.rb#L4

Set the controller to get the hidden file and calling the base method to update file. 

* https://github.com/mariohmol/paperclip-keeponvalidation/blob/master/app/controllers/users_controller.rb#L5

In your view, add a hidden file and a div showing the actual file.

* https://github.com/mariohmol/paperclip-keeponvalidation/blob/master/app/views/_form.html.erb#L10

# Multiple files

WIll be doc soon.. 
