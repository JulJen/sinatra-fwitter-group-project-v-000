class User < ActiveRecord::Base
  has_many :tweets
  has_secure_password

  def slug
    self.username.gsub(" ", "-").downcase
    # obj = self.name.downcase
    # obj.gsub(" ", "-")
  end

  def self.find_by_slug(slug)
    User.all.find{|name| name.slug == slug}
  end


end
