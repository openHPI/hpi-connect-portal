class AddBookedAtToEmployers < ActiveRecord::Migration
  def change
    add_column :employers, :booked_at, :datetime
    reversible do |dir|
      dir.up { Employer.paying.update_all booked_at: Date.today }
    end
  end
end
