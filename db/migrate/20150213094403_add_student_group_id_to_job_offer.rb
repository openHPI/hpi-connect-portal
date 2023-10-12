class AddStudentGroupIdToJobOffer < ActiveRecord::Migration[4.2]
  def change
    add_column :job_offers, :student_group_id, :integer, null: false, default: 0
  end
end
