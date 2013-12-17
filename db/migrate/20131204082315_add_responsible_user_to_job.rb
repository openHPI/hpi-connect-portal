class AddResponsibleUserToJob < ActiveRecord::Migration
  def change
    add_column :job_offers, :responsible_user_id, :integer
  end
end
