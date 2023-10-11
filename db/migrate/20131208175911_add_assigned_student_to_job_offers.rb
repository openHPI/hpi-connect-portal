class AddAssignedStudentToJobOffers < ActiveRecord::Migration[4.2]
  def change
  	add_column :job_offers, :assigned_student_id, :integer
  end
end
