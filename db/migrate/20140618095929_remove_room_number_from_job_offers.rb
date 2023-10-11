class RemoveRoomNumberFromJobOffers < ActiveRecord::Migration[4.2]
  def change
  	remove_column :job_offers, :room_number, :string
  end
end
