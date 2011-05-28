module Api
  class Post
    include Representable::JSON
    representable_property :title
    representable_property :content
    representable_property :user, :as => SimpleUser
  end
end

