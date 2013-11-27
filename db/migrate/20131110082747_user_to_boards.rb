class UserToBoards < ActiveRecord::Migration
  def up
    create_table :user_to_boards do |t|
      t.integer  :user_id
      t.integer  :board_id
      t.datetime :created_at
      t.timestamp :updated_at
    end  
  end

  def down
    drop_table :user_to_boards
  end
end
