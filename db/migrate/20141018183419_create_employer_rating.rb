class CreateEmployerRating < ActiveRecord::Migration
  def change
    create_table :employer_ratings do |t|
      t.integer :user_id
      t.integer :employer_id
      t.integer :rating
      t.text :recension
    end
  end
end
