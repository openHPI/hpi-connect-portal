class CreateNewsletterOrders < ActiveRecord::Migration[4.2]
  def change
    create_table :newsletter_orders do |t|
      t.belongs_to :student
      t.text :search_params

      t.timestamps
    end
  end
end
