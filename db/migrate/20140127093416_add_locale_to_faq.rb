class AddLocaleToFaq < ActiveRecord::Migration
  def change
  	add_column :faqs, :locale, :string
  end
end
