module AlumniMergeHelper

  # Create the alumnus if he doesn't exist yet or merge the existing one with the row content
  def self.merge_from_row(row)
    alumni = Alumni.new
    begin
      clean_alumni_row(row)
    rescue Exception => e
      alumni.errors.add(:base, e.message)
    end

    existing_alumni = already_existing_alumni(row)
    if existing_alumni
      # Merge alumni data from row into existing alumni
      existing_alumni.update!(firstname: row[:vorname]) if not existing_alumni.firstname
      existing_alumni.update!(lastname: row[:lastname]) if not existing_alumni.lastname
      existing_alumni.update!(email: row[:email]) if not existing_alumni.email
      alumni = existing_alumni
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

  def self.clean_alumni_row(row)
    row = generate_alumni_email_from_emails(row)
    row[:alumnimail] = row[:alumnimail]
    row[:vorname] ||= row[:alumnimail].split('@')[0].split('.')[0].capitalize
    row[:nachname] ||= row[:alumnimail].split('@')[0].split('.')[1].capitalize
    return row
  end

  def self.generate_alumni_email_from_emails(row)
    if row[:alumnimail].to_s == ''
      private_mails = get_all_emails(row)
      private_mails.map!{|email| email.sub("@student.hpi.uni-potsdam.de", "").sub("@hpi.de", "").sub("@student.hpi.de", "").sub("@hpi-alumni.de", "")}
      user_names = private_mails.reject{|user_name| user_name.include?("@")}
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
    private_mails = row[:weitere_emailadresse].split(';').collect{|x| x.strip || x }
    private_mails.push(row[:private_email])
    return private_mails
  end

  def self.generate_alumni_email_from_name(row)
    firstname = (row[:vorname].include?(' ') ? row[:vorname].split(' ')[0].downcase : row[:vorname])
    lastname = (row[:nachname].include? ' ' ? row[:nachname].split(' ')[0].downcase : row[:nachname])
    "GENERATED_" + firstname + "." + lastname + "@hpi-alumni.de"
  end

  def self.already_existing_alumni(row)
    alumni_email = row[:alumnimail]
    found_alumnis = Alumni.where(alumni_email: alumni_email)

    unless found_alumnis.empty?
      return found_alumnis.first
    end

    private_mails = get_all_emails row
    found_alumnis = Alumni.where(email: private_mails)
    if found_alumnis.empty?
      return nil
    else
      return found_alumnis.first
    end
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
