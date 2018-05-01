class User < ActiveRecord::Base
  has_many :tweets

end


# Users should have a username, email, and password, and have many tweets.
