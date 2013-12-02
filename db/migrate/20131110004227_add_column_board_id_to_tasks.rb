class AddColumnBoardIdToTasks < ActiveRecord::Migration
  def up
    add_column :tasks, :board_id, :integer, :after => :id
  end

  def down
    remove_column :tasks, :board_id
  end
end
