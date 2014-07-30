class RemoveAcademicProgramIdFromJobOffers < ActiveRecord::Migration
  def change
    remove_column :job_offers, :academic_program_id, :integer
  end
end
