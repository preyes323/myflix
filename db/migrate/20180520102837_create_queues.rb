class CreateQueues < ActiveRecord::Migration[5.1]
  def change
    create_table :my_queues do |t|
      t.integer :video_id, :user_id, :position
      t.timestamps
    end
  end
end
