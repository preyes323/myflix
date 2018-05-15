class CreateVideoReviews < ActiveRecord::Migration[5.1]
  def change
    create_table :video_reviews do |t|
      t.integer :video_id
      t.integer :user_id
      t.integer :rating
      t.text :review

      t.timestamps
    end

    add_index :video_reviews, [:video_id, :user_id], unique: true
  end
end
