class AddCategoryToJobOffer < ActiveRecord::Migration[4.2]
  def change
    add_column :job_offers, :category_id, :integer, null: false, default: 0
  end
end
