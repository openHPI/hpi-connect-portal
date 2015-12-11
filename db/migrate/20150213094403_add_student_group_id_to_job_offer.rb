class AddStudentGroupIdToJobOffer < ActiveRecord::Migration
  def change
    add_column :job_offers, :student_group_id, :integer, null: false, default: 0
  end
end
