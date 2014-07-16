class RemoveRoomNumberFromJobOffers < ActiveRecord::Migration
  def change
  	remove_column :job_offers, :room_number, :string
  end
end
