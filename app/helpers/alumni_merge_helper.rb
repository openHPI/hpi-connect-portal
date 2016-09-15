module AlumniMergeHelper

  # Create the alumnus if he doesn't exist yet or merge the existing one with the row content
  def self.merge_from_row(row)
    alumni = Alumni.new
    begin
      clean_alumni_row(row)
    rescue Exception => e
      alumni.errors.add(:base, e.message)
      logger.error e.message
    end

    # Retrieve the already existing user
    existing_alumnus = get_existing_alumnus(row)

    if existing_alumnus
      alumni = merge_data_into_alumnus(existing_alumnus, row)
    else
      # Create new alumni from row
      row = transform_row_for_alumnus_creation(row)
      alumni = Alumni.create_from_row_and_invite row, false
      if alumni != :created
        alumni.errors.add(:base, "Unable to create #{row[:firstname]} #{row[:lastname]} from row")
        return
      end
      alumni = Alumni.where(alumni_email: row[:alumni_email]).first
      alumni.update_attributes! hidden_title: row[:akad_titel], hidden_birth_name: row[:geburtsname], hidden_graduation_year: row[:jahr],
                                hidden_graduation_id: get_graduation_id(row), hidden_private_email: row[:private_email], hidden_alumni_email: row[:alumnimail],
                                hidden_additional_email: row[:weitere_emailadresse], hidden_last_employer: row[:letztes_unternehmen],
                                hidden_current_position: row[:aktuelle_position], hidden_street: row[:strae], hidden_location: row[:ort],
                                hidden_postcode: row[:plz], hidden_country: row[:land], hidden_phone_number: row[:telefon],
                                hidden_comment: row[:notiz], hidden_agreed_alumni_work: row[:einverstndnis_alumniarbeit_erteilt]
    end
    return alumni
  end

  def self.merge_data_into_alumnus(existing_alumnus, row)
    existing_alumnus.update!(firstname: row[:vorname]) if not existing_alumnus.firstname
    existing_alumnus.update!(lastname: row[:lastname]) if not existing_alumnus.lastname
    existing_alumnus.update!(email: row[:private_email]) if not existing_alumnus.email
    existing_alumnus.update!(hidden_title: row[:akad_titel])
    existing_alumnus.update!(hidden_birth_name: row[:geburtsname])
    existing_alumnus.update!(hidden_graduation_year: row[:jahr])
    existing_alumnus.update!(hidden_graduation_id: get_graduation_id(row))
    existing_alumnus.update!(hidden_private_email: row[:private_email])
    existing_alumnus.update!(hidden_alumni_email: row[:alumnimail])
    existing_alumnus.update!(hidden_additional_email: row[:weitere_emailadresse])
    existing_alumnus.update!(hidden_last_employer: row[:letztes_unternehmen])
    existing_alumnus.update!(hidden_current_position: row[:aktuelle_position])
    existing_alumnus.update!(hidden_street: row[:strae])
    existing_alumnus.update!(hidden_location: row[:ort])
    existing_alumnus.update!(hidden_postcode: row[:plz])
    existing_alumnus.update!(hidden_country: row[:land])
    existing_alumnus.update!(hidden_phone_number: row[:telefon])
    existing_alumnus.update!(hidden_comment: row[:notiz])
    existing_alumnus.update!(hidden_agreed_alumni_work: row[:einverstndnis_alumniarbeit_erteilt])
    return existing_alumnus  
  end

  def self.transform_row_for_alumnus_creation(row)
    row[:firstname] = row[:vorname]
    row[:lastname] = row[:nachname]
    row[:alumni_email] = row[:alumnimail].sub("@hpi-alumni.de", "") if row[:alumnimail]
    row[:alumni_email] ||= "GENERATED_#{row[:firstname].downcase}.#{row[:lastname].downcase}"
    row[:email] ||= row[:weitere_emailadresse].split(';')[0] if row[:weitere_emailadresse]
    return row
  end

  def self.get_existing_alumnus(row)
    invited_alumnus = get_invited_alumnus(row)
    if invited_alumnus
      return invited_alumnus
    end
    registered_alumnus = get_registered_alumnus(row)
    if registered_alumnus
      return registered_alumnus
    end
    return nil
  end

  def self.get_registered_alumnus(row)
    private_emails = get_all_emails row
    found_students = User.where(alumni_email: row[:alumnimail])
    unless found_students.empty?
      return Student.find(found_students.first.manifestation_id)
    end
    found_students = User.where(email: private_emails, manifestation_type: "Student")
    unless found_students.empty?
      return Student.find(found_students.first.manifestation_id)
    end
  end

  def self.get_invited_alumnus(row)
    found_alumni = Alumni.where(alumni_email: row[:alumnimail])
    unless found_alumni.empty?
      return found_alumni.first
    end
    private_emails = get_all_emails row
    found_alumni = Alumni.where(email: private_emails)
    unless found_alumni.empty?
      return found_alumni.first
    end
  end

  def self.clean_alumni_row(row)
    row = generate_alumni_email_from_emails(row)
    row[:alumnimail] = row[:alumnimail].sub("@hpi-alumni.de", "")
    row[:vorname] ||= row[:alumnimail].split('.')[0].capitalize
    row[:nachname] ||= row[:alumnimail].split('.')[1].capitalize
    return row
  end

  def self.generate_alumni_email_from_emails(row)
    if row[:alumnimail].to_s == ''
      private_emails = get_all_emails(row)
      private_emails.map!{|email| email.sub("@student.hpi.uni-potsdam.de", "").sub("@hpi.de", "").sub("@student.hpi.de", "").sub("@hpi-alumni.de", "")}
      user_names = private_emails.reject{|user_name| user_name.include?("@")}
      user_names.reject!{|user_name| user_name.to_s == ''}
      user_names.uniq!

      if user_names.length == 1
        #Generate HPI alumni mail from found HPI username
        row[:alumnimail] = user_names[0]
      else
        # Generate HPI alumni mail from first and last name
        row[:alumnimail] = generate_alumni_email_from_name(row)
      end
    else
      row[:alumnimail] = row[:alumnimail].sub("@hpi-alumni.de", "")
    end
    return row
  end

  def self.get_all_emails(row)
    row[:private_email] ||= ''
    row[:weitere_emailadresse] ||= ''
    private_emails = row[:weitere_emailadresse].split(';').collect{|x| x.strip || x }
    private_emails.push(row[:private_email])
    return private_emails
  end

  def self.generate_alumni_email_from_name(row)
    firstname = row[:vorname].include?(' ') ? row[:vorname].split(' ')[0].downcase : row[:vorname].downcase
    lastname = row[:nachname].include?(' ') ? row[:nachname].split(' ')[0].downcase : row[:nachname].downcase
    "GENERATED_" + firstname + "." + lastname
  end

  def self.get_graduation_id(row)
    if row[:abschluss]
      graduation = row[:abschluss].downcase
      graduation = "phd" if graduation == "promotion"
      return Student::GRADUATIONS.index(graduation)
    else
      return Student::GRADUATIONS.index("bachelor")
    end
  end
end
