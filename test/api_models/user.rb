module Api
  class User
    include Representable::JSON
    representable_property :fullname
    representable_property :email
  end
end

module Api
  class SimpleUser
    include Representable::JSON
    representable_property :fullname
  end
end
