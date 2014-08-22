class DataMigrationForGraduationId < ActiveRecord::Migration
  def up
    JobOffer.all.each do |job_offer|
      unless job_offer.graduation_id.nil?
        unless job_offer.graduation_id == 0
          job_offer.update!(graduation_id: (job_offer.graduation_id - 1))
        end
      end
    end
  end

  def down
    JobOffer.all.each do |job_offer|
      unless job_offer.graduation_id.nil?
        unless job_offer.graduation_id == Student::GRADUATIONS.index(Student::GRADUATIONS.last)
          job_offer.update!(graduation_id: (job_offer.graduation_id + 1))
        end
      end
    end
  end
end
