class ChangeDateFormatInMyTable < ActiveRecord::Migration[4.2]
  def up
   change_column :job_offers, :description, :text
   change_column :job_offers, :start_date, :date
   change_column :job_offers, :end_time, :date
  end

  def down
   change_column :job_offers, :description, :text
   change_column :job_offers, :start_date, :datetime
   change_column :job_offers, :end_time, :datetime
  end
end
