class CreateRatings < ActiveRecord::Migration[4.2]
  def change
    create_table :ratings do |t|
      t.references :student, index: true
      t.references :employer, index: true
      t.references :job_offer, index: true
      t.string :headline
      t.text :description
      t.integer :score_overall
      t.integer :score_atmosphere
      t.integer :score_salary
      t.integer :score_work_life_balance
      t.integer :score_work_contents
    end
  end
end
