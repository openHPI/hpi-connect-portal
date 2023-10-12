class RemoveResponsibleUserIdFromJobOffer < ActiveRecord::Migration[4.2]
  def change
  	remove_column :job_offers, :responsible_user_id
  end
end
