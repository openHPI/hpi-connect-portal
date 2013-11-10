class ChangeDateFormatInMyTable < ActiveRecord::Migration
  def self.up
   change_column :job_offers, :description, :text
   change_column :job_offers, :start_date, :date
   change_column :job_offers, :end_time, :date
  end

  def self.down
   change_column :job_offers, :description, :text
   change_column :job_offers, :start_date, :datetime
   change_column :job_offers, :end_time, :datetime
  end
end
