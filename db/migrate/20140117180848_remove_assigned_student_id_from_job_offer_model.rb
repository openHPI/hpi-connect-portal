class RemoveAssignedStudentIdFromJobOfferModel < ActiveRecord::Migration
  def change
  	remove_column :job_offers, :assigned_student_id
  end
end
