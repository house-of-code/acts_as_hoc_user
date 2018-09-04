# ActsAsHocUser

`acts_as_hoc_user` makes it easy to authenticate users.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'acts_as_hoc_user'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install acts_as_hoc_user


## Usage

### Generate model
You can create the model and table migration with the following generator:
```bash
$ rails generate acts_as_hoc_user:hoc_user NAME FIELDS
```

Eg.
```bash
$ rails generate hoc_user user name:string age:integer phone_number:string address:string zip:string
```
Which will generate the following migration:
```ruby
#db/migration/xxxxxxxxxxxx_create_users.rb
class CreateUsers < ActiveRecord::Migration[5.0]
  def self.up
    create_table :users do |t|
      t.string :email, index: {unique: true}, null: false
      t.string :password_digest
      t.string :name
      t.integer :age
      t.string :phone_number
      t.string :address
      t.string :zip
      t.timestamps
    end
  end

  def self.down
    drop_table :users
  end
end
```
and model
```ruby
#app/model/user.rb
class User < ActiveRecord::Base
  acts_as_hoc_user
end
```

and initializer
```ruby
#config/initializers/acts_as_hoc_user.rb
ActsAsHocUser.configure do |config|
  config.min_password_length = 6
end
```

### Manual usage
If you prefer you can create the model yourself. Just make sure that the model has email:string and password_digest:string fields and add `acts_as_hoc_user` to the model

### Authenticate user

#### Authenticate and get JWT token
 ```ruby
 auth_token = User.authenticate_with_credentials("email@test.com","s3cr3t")
 ```

#### Authenticate with JWT token
```ruby
user = User.authenticate_with_authentication_token(auth_token)
```

#### Authenticate with http headers
```ruby
user = User.authenticate_with_headers(request.headers)
```


## Licence
The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
