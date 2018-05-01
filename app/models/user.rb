class User < ActiveRecord::Base
  has_many :tweets
  has_secure_password

end


# Users should have a username, email, and password, and have many tweets.
