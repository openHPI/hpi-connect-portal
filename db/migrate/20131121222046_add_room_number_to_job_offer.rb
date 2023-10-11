class AddRoomNumberToJobOffer < ActiveRecord::Migration[4.2]
  def change
    add_column :job_offers, :room_number, :string
  end
end
