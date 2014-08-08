#ActiveRecord based global configurations

##Functionality
 - Ability to store, read and delete unique settings in the database
 - settings can be boolean, strings, numbers or null(should work for arrays and hashes too, havent tested it out though)
 - Cache the configurations while storing and reading(in the event they aren't in the cache). 
 - Remove from the cache in the event of deleting configurations.
 

## Usage
 ```ruby
   Configuration.save 'email', 'john@doe.com' # returns john@doe.com
   Configuration.save 'flag', false           # returns false
   Configuration.save 'flag', true            # Returns a duplicate exception
   
   Configuration.read 'email'   # returns john@doe.com
   Configuration.read 'flag',   # returns false
   Configuration.read 'foo',    # returns not found exception
   
   Configuration.delete 'email' # returns true
   Configuration.delete 'foo',  # returns not found exception
 ```

## Decisions and justifications
 - The Interface prevents users from being able to update existing configurations. The thought process behind this is that configurations are generally of a high importance. In order to modify a configuration the existing configuration would have to be destroyed followed by creating the new one. This serves as a means to emphasize the importance of the changes.  If however, the configurations aren't too important and are subject to being changed often, having an update method or perhaps incorporating updations into the save functionality might make sense.  
 - The validations are at the database level.
 - In the events of failures exceptions are raised. Since this model deals with configurations which might have an high impact on the overall code, raising an exception makes more sense. Returning falses or nils might go unnoticed.


## Potential additions
 - A method that returns all the existing settings. Though it wouldn't make sense 
 - If the settings aren't critical, Have an update method 
