class AddEnglishDescriptionToEmployers < ActiveRecord::Migration[5.1]
  def change
    add_column :employers, :description_en, :text
    rename_column :employers, :description, :description_de
  end
end
