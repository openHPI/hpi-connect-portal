class AddResponsibleUserToJob < ActiveRecord::Migration[4.2]
  def change
    add_column :job_offers, :responsible_user_id, :integer
  end
end
