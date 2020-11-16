class AddPackageBookingDateToEmployers < ActiveRecord::Migration[6.0]
  def change
  	add_column :employers, :package_booking_date, :datetime, default: nil
  end
end
