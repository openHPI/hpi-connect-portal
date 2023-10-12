class FaqColumnName < ActiveRecord::Migration[4.2]
  def change
  	rename_column :faqs, :title, :question
  	rename_column :faqs, :text, :answer
  end
end
