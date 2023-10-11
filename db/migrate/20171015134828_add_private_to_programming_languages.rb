class AddPrivateToProgrammingLanguages < ActiveRecord::Migration[5.1]
  def change
    add_column :programming_languages, :private, :boolean, default: false
  end
end
