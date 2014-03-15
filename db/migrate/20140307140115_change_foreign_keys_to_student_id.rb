class ChangeForeignKeysToStudentId < ActiveRecord::Migration

  def up
    rename_column :applications, :user_id, :student_id
    rename_column :languages_users, :user_id, :student_id
    rename_column :programming_languages_users, :user_id, :student_id
    rename_column :programming_languages_newsletter_informations, :user_id, :student_id

    drop_table :job_offers_users
    create_table :job_offers_students, id: false do |t|
      t.integer :job_offer_id
      t.integer :student_id
    end
    add_index :job_offers_students, [:job_offer_id, :student_id], unique: true, name: "jo_s_index"
  end

  def down
    rename_column :applications, :student_id, :user_id
    rename_column :languages_users, :student_id, :user_id
    rename_column :programming_languages_users, :student_id, :user_id
    rename_column :programming_languages_newsletter_informations, :student_id, :user_id

    drop_table :job_offers_students
    create_table :job_offers_users, id: false do |t|
      t.integer :job_offer_id
      t.integer :user_id
    end
    add_index :job_offers_users, [:job_offer_id, :user_id], unique: true, name: "jo_u_index"
  end
end
