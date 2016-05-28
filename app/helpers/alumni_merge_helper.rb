module AlumniMergeHelper

  def self.get_all_emails(row)
    row[:private_email] ||= ''
    row[:weitere_emailadresse] ||= ''
    private_mails = row[:weitere_emailadresse].split(';').collect{|x| x.strip || x }
    private_mails.push(row[:private_email])
    return private_mails
  end

  def self.generate_alumni_email_from_emails(row)
    if row[:alumnimail].to_s == ''
      private_mails = get_all_emails(row)
      private_mails.map!{|email| email.sub("@student.hpi.uni-potsdam.de", "").sub("@hpi.de", "").sub("@student.hpi.de", "").sub("@hpi-alumni.de", "")}
      user_names = private_mails.reject{|user_name| user_name.include?("@")}
      user_names.reject!{|user_name| user_name.to_s == ''}
      user_names.uniq!

      if user_names.length == 0
        raise "Could not generate hpi user name from emails"
      elsif user_names.length > 1        
        raise "Found multiple hpi user names: " + user_names.to_s
      end
      row[:alumnimail] = user_names[0] + "@hpi-alumni.de"
    end
    return row
  end

  def self.clean_alumni_row(row)
    row = generate_alumni_email_from_emails(row)
    row[:alumnimail] = row[:alumnimail].split('@')[0]
    row[:vorname] ||= row[:alumnimail].split('.')[0].capitalize
    row[:nachname] ||= row[:alumnimail].split('.')[1].capitalize
    return row
  end

  def self.merge_from_row(row)
    alumni = Alumni.new
    begin
      clean_alumni_row(row)
    rescue Exception => e
      alumni.errors.add(:base, e.message)
    end
    if alredy_existing_alumni row

    else
      #Alumni.new firstname: row[:vorname], lastname: row[:nachname]
    end
    return alumni
  end

  def self.alredy_existing_alumni(row)
    alumni_email = row[:alumnimail]
    found_alumni = Alumni.where(alumni_email: alumni_email)
    unless found_alumni.empty?
      return found_alumni.first
    end

    private_mails = get_all_emails row
    found_alumni = Alumni.where(email: private_mails)
    unless found_alumni.empty?
      return true
    end
    return false
  end
end
