class CreateStaffs < ActiveRecord::Migration[4.2]
  def change
    create_table :staffs do |t|
      t.integer :employer_id

      t.timestamps
    end
  end
end
