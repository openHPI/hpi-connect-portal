class RemoveAssignedStudentIdFromJobOfferModel < ActiveRecord::Migration[4.2]
  def change
  	remove_column :job_offers, :assigned_student_id
  end
end
