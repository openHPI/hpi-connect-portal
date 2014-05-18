class RemoveResponsibleUserIdFromJobOffer < ActiveRecord::Migration
  def change
  	remove_column :job_offers, :responsible_user_id
  end
end
