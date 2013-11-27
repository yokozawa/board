class CreateUsers < ActiveRecord::Migration
  def up
    create_table :users do |t|
      t.string   :name
      t.string   :email
      t.string   :password_hash
      t.datetime :created_at
      t.timestamp :updated_at
      t.integer  :delete_flg
    end
  end

  def down
    drop_table :users
  end
end
