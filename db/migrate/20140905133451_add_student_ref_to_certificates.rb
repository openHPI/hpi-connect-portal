class AddStudentRefToCertificates < ActiveRecord::Migration
  def change
    add_reference :certificates, :student, index: true
  end
end
