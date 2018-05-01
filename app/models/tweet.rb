class Tweet < ActiveRecord::Base
  belongs_to :user

end



#Tweets should have content, belong to a user.
