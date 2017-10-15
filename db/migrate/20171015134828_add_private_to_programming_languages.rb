class AddPrivateToProgrammingLanguages < ActiveRecord::Migration
  def change
    add_column :programming_languages, :private, :boolean, default: false
  end
end
