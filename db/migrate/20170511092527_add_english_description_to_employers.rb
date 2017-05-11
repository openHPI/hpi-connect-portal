class AddEnglishDescriptionToEmployers < ActiveRecord::Migration
  def change
    add_column :employers, :description_en, :text
    rename_column :employers, :description, :description_de
  end
end
