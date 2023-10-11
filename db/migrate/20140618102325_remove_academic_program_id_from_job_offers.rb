class RemoveAcademicProgramIdFromJobOffers < ActiveRecord::Migration[4.2]
  def change
    remove_column :job_offers, :academic_program_id, :integer
  end
end
