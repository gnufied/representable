puts "Loading post class"
class Post < ActiveRecord::Base
  belongs_to :user
end
