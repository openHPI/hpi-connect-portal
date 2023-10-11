class AddCompanyToContacts < ActiveRecord::Migration[5.2]
  def change
    add_column :contacts, :company, :string
  end
end
