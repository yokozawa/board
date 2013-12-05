class AddPasswordSaltToUsers < ActiveRecord::Migration
  def up
    add_column :users, :password_salt, :string, :after => :password_hash
  end

  def down
    remove_column :users, :password_salt
  end
end
