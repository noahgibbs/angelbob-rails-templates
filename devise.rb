require File.join(File.expand_path(File.dirname(__FILE__)), "template_utils")

gem "devise", '1.1.rc2'
#run "bundle install"

run "rm public/index.html"
generate "controller", "Home", "index"
route "root :to => 'home#index'"

generate "devise:install"
gsub_in_file(/^end$/, "  config.action_mailer.default_url_options = { :host => '#{app_name}.local' }\nend", 'config/environments/development.rb')

generate "devise", "User"

create_users_file = Dir['db/migrate/*_create_users.rb'].first
run "rm #{create_users_file}"
file create_users_file, <<-RUBY.gsub(/^  /, '')
  class DeviseCreateUsers < ActiveRecord::Migration
    def self.up
      create_table(:users) do |t|
        t.string :name

        t.database_authenticatable :null => false
        t.confirmable
        t.recoverable
        t.rememberable
        t.trackable
        t.lockable

        t.timestamps
      end

      add_index :users, :email,                :unique => true
      add_index :users, :confirmation_token,   :unique => true
      add_index :users, :reset_password_token, :unique => true
      add_index :users, :unlock_token,         :unique => true
    end

    def self.down
      drop_table :users
    end
  end
RUBY
run 'rm app/models/user.rb'
file 'app/models/user.rb', <<-EOS.gsub(/^  /, '')
  class User < ActiveRecord::Base
    # Include default devise modules. Others available are:
    # :token_authenticatable, :timeoutable and :activatable
    devise :registerable, :database_authenticatable, :recoverable,
           :rememberable, :trackable, :validatable, :lockable

    # Setup accessible (or protected) attributes for your model
    attr_accessible :email, :password, :password_confirmation, :name
  end
EOS

git :init
git :add => "."
git :commit => "-m 'Initial commit from Devise template'"
