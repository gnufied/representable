require_relative 'test_helper'
require 'representable/json'


require_relative "models/user"
require_relative "models/post"
require_relative "api_models/user"
require_relative "api_models/post"

ActiveRecord::Base.configurations = {
  'test' => {
    :adapter  => 'sqlite3',
    :encoding => 'utf8',
    :pool => 1,
    :timeout => 5000,
    :database => 'test.sqlite3'
  }
}

ActiveRecord::Base.establish_connection('test')

class JsonActiveRecordTest < MiniTest::Spec
  describe "serializing ActiveRecord objects" do
    before(:each) do
      Post.connection.drop_table('posts') if Post.connection.table_exists?(:posts)
      User.connection.drop_table('users') if User.connection.table_exists?(:users)

      User.connection.create_table :users do |u|
        u.column :fullname, :string
        u.column :email, :string
      end

      Post.connection.create_table :posts do |post|
        post.column :title, :string
        post.column :content, :string
        post.column :user_id, :integer
      end
    end

    it "should serliaze based on representable property" do
      u = User.create(:fullname => "foo", :email => "foo@example.com")
      post = Post.new(:title => "Hey", :content => "Bye", :user_id => u.id)
      post.save

      api_post = Api::Post.new(post)
      data = JSON[api_post.to_json]
      assert_equal "hey", data["post"]["title"]
      assert_equal "Bye", data["post"]["content"]
      assert_equal "foo", data["post"]["user"]["fullname"]
    end
  end
end
