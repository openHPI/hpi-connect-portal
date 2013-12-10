class FaqColumnName < ActiveRecord::Migration
  def change
  	rename_column :faqs, :title, :question
  	rename_column :faqs, :text, :answer
  end
end
