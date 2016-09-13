module AlumniMergeHelper

  # Create the alumnus if he doesn't exist yet or merge the existing one with the row content
  def self.merge_from_row(row)
    alumni = Alumni.new
    begin
      clean_alumni_row(row)
    rescue Exception => e
      alumni.errors.add(:base, e.message)
    end

    # Retrieve the already existing user
    existing_user = get_existing_user(row)

    if existing_user
      # Merge alumni data from row into existing user
      existing_user.update!(firstname: row[:vorname]) if not existing_user.firstname
      existing_user.update!(lastname: row[:lastname]) if not existing_user.lastname
      existing_user.update!(email: row[:private_email]) if not existing_user.email
      existing_user.update!(hidden_title: row[:akad_titel])
      existing_user.update!(hidden_birth_name: row[:geburtsname])
      existing_user.update!(hidden_graduation_year: row[:jahr])
      existing_user.update!(hidden_graduation_id: get_graduation_id(row))
      existing_user.update!(hidden_private_email: row[:private_email])
      existing_user.update!(hidden_alumni_email: row[:alumnimail])
      existing_user.update!(hidden_additional_email: row[:weitere_emailadresse])
      existing_user.update!(hidden_last_employer: row[:letztes_unternehmen])
      existing_user.update!(hidden_current_position: row[:aktuelle_position])
      existing_user.update!(hidden_street: row[:strae])
      existing_user.update!(hidden_location: row[:ort])
      existing_user.update!(hidden_postcode: row[:plz])
      existing_user.update!(hidden_country: row[:land])
      existing_user.update!(hidden_phone_number: row[:telefon])
      existing_user.update!(hidden_comment: row[:notiz])
      existing_user.update!(hidden_agreed_alumni_work: row[:einverstndnis_alumniarbeit_erteilt])
      alumni = existing_user
    else
      # Create new alumni from row
      user = User.new firstname: row[:vorname], lastname: row[:nachname], email: row[:private_email], alumni_email: row[:alumnimail]
      student = Student.new hidden_title: row[:akad_titel], hidden_birth_name: row[:geburtsname], hidden_graduation_year: row[:jahr],
                            hidden_graduation_id: get_graduation_id(row), hidden_private_email: row[:private_email], hidden_alumni_email: row[:alumnimail],
                            hidden_additional_email: row[:weitere_emailadresse], hidden_last_employer: row[:letztes_unternehmen],
                            hidden_current_position: row[:aktuelle_position], hidden_street: row[:strae], hidden_location: row[:ort],
                            hidden_postcode: row[:plz], hidden_country: row[:land], hidden_phone_number: row[:telefon],
                            hidden_comment: row[:notiz], hidden_agreed_alumni_work: row[:einverstndnis_alumniarbeit_erteilt]
      user.manifestation = student
      return student
    end
    return alumni
  end

  def self.get_existing_user(row)
    existing_user = get_existing_alumni(row)
    if existing_user
      return existing_user
    end
    existing_student = get_existing_student(row)
    if existing_student
      return existing_student
    end
    return nil
  end

  def self.get_existing_student(row)
    private_emails = get_all_emails row
    found_students = User.where(email: private_emails, manifestation_type: "Student")
    if found_students.empty?
      return nil
    else
      return found_students.first
    end
  end

  def self.get_existing_alumni(row)
    found_alumnis = Alumni.where(alumni_email: row[:alumnimail])

    unless found_alumnis.empty?
      return found_alumnis.first
    end

    private_emails = get_all_emails row
    found_alumnis = Alumni.where(email: private_emails)
    if found_alumnis.empty?
      return nil
    else
      return found_alumnis.first
    end
  end

  def self.clean_alumni_row(row)
    row = generate_alumni_email_from_emails(row)
    row[:alumnimail] = row[:alumnimail]
    row[:vorname] ||= row[:alumnimail].split('@')[0].split('.')[0].capitalize
    row[:nachname] ||= row[:alumnimail].split('@')[0].split('.')[1].capitalize
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
        row[:alumnimail] = user_names[0] + "@hpi-alumni.de"
      else
        # Generate HPI alumni mail from first and last name
        row[:alumnimail] = generate_alumni_email_from_name(row)
      end
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
    "GENERATED_" + firstname + "." + lastname + "@hpi-alumni.de"
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
