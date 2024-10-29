class CreateJobStatuses < ActiveRecord::Migration[4.2]
  def change
    create_table :job_statuses do |t|
      t.string :name

      t.timestamps
    end
    remove_column :job_offers, :status
    add_column :job_offers, :status_id, :integer
  end
end
