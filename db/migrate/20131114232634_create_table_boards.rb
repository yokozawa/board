class CreateTableBoards < ActiveRecord::Migration
  def up
    create_table :boards do |t|
      t.string    :title
      t.string    :description
      t.datetime  :created_at
      t.timestamp :updated_at
      t.integer   :delete_flg
    end
  end

  def down
    drop_table :boards
  end
end
