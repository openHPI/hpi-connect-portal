class AddAcademicProgramIdToJobOffer < ActiveRecord::Migration
  def change
    add_column :job_offers, :academic_program_id, :integer, null: true, default: nil
  end
end
