class CreateCertificates < ActiveRecord::Migration
  def change
    create_table :certificates do |t|

      t.timestamps
    end
  end
end
