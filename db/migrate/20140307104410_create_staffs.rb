class CreateStaffs < ActiveRecord::Migration
  def change
    create_table :staffs do |t|
      t.integer :employer_id

      t.timestamps
    end
  end
end
