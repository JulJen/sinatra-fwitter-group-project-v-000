class CreateTweets < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :content
  end
end
