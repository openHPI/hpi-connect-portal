class AddAssignedStudentToJobOffers < ActiveRecord::Migration
  def change
  	add_column :job_offers, :assigned_student_id, :integer
  end
end
