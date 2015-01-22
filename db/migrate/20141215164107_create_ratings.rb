class CreateRatings < ActiveRecord::Migration
  def change
    create_table :ratings do |t|
      t.references :student, index: true
      t.references :employer, index: true
      t.references :job_offer, index: true
      t.integer :score
      t.string :headline
      t.text :description

      t.timestamps
    end
  end
end
