class AddLocaleToFaq < ActiveRecord::Migration[4.2]
  def change
  	add_column :faqs, :locale, :string
  end
end
