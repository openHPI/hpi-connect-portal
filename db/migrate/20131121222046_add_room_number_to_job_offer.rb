class AddRoomNumberToJobOffer < ActiveRecord::Migration
  def change
    add_column :job_offers, :room_number, :string
  end
end
