class AddIndexToMyQueues < ActiveRecord::Migration[5.1]
  def change
    add_index :my_queues, [:user_id, :video_id], unique: true
  end
end
