class Board < ActiveRecord::Base
  has_many:tasks
  has_many:user_to_boards
  has_many:users, :through => :user_to_boards
#  attr_accessible:user_ids
end