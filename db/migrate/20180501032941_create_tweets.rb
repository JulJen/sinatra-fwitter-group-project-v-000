class CreateTweets < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :content
      t.integer :user_id
  end
end
