class ChangeHiddenAgreedToAlumniWork < ActiveRecord::Migration
  def change
  	change_column :students, :hidden_agreed_alumni_work, :string, :default => nil
  end
end
