class CreateUser < ActiveRecord::Migration[5.1]
  def change
    create_table :users do |t|
      t.string :email
      t.text :password_digest
      t.string :full_name

      t.timestamps
    end
  end
end
