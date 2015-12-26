#!bin/env ruby
# encoding: utf-8

REQUEST = false

require 'xing_api'

def get_language_name(n)
    case n
    when "en"
      return "english"
    when "de"
      return "german"
    when "es"
      return "spanish"
    when "fr"
      return "french"
   when "zh"
      return "chinese"
    when "pt"
      return "portuguese"
    when "it"
      return "italian"
    when "ru"
      return "russian"
    when "pl"
      return "polish"
    when "sv"
      return "swedish"
    when "fi"
      return "finnish"
    else
      return -1
    end
end

def get_skill(string)
    case string
    when "NATIVE"
    return 5
    when "FLUENT"
      return 4
    when "GOOD"
      return 2
    else
      return 1
    end
end

userdata = {
  :id=>"20263378_edc2ad",
  :active_email=>"mschenker@live.de",
  :badges=>[],
  :birth_date=>{:year=>1979,:month=>1,:day=>5},
  :business_address=>{:street=>nil,:zip_code=>nil,:city=>"München",:province=>nil,:country=>"DE",:email=>nil,:fax=>nil,:phone=>nil,:mobile_phone=>nil},
  :display_name=>"Martin Schenker",
  :educational_background=>{
    :schools=>[{
      :name=>"Bamberg",:subject=>"Informatik",:degree=>"Master",:begin_date=>"2011-05",:end_date=>nil,:notes=>nil}],
    :qualifications=>["Ich bin qualifiziert"]},
  :employment_status=>"RETIRED",
  :first_name=>"Martin",
  :gender=>"m",
  :haves=>"das biete ich",
  :instant_messaging_accounts=>{},
  :interests=>"auto fahren",
  :languages=>{
    :de=>"NATIVE",  :fr=>"GOOD"},
  :last_name=>"Schenker",
  :organisation_member=>"eine Organisation",
  :page_name=>"Martin_Schenker3",
  :permalink=>"https://www.xing.com/profile/Martin_Schenker3",
  :photo_urls=>{:thumb=>"https://www.xing.com/img/n/nobody_m.30x40.jpg",:large=>"https://www.xing.com/img/n/nobody_m.140x185.jpg",:mini_thumb=>"https://www.xing.com/img/n/nobody_m.18x24.jpg",:maxi_thumb=>"https://www.xing.com/img/n/nobody_m.70x93.jpg",:medium_thumb=>"https://www.xing.com/img/n/nobody_m.57x75.jpg"},
  :premium_services=>[],
  :private_address=>{:street=>nil,:zip_code=>nil,:city=>nil,:province=>nil,:country=>nil,:email=>"mschenker@live.de",:fax=>nil,:phone=>nil,:mobile_phone=>nil},
  :professional_experience=>{
    :primary_company=>{
      :name=>"Computronics",
      :url=>nil,
      :tag=>"COMPUTRONICS",
      :title=>"IT",
      :begin_date=>nil,
      :end_date=>nil,
      :description=>"computerstuff",
      :industry=>"COMPUTER_SOFTWARE",
      :company_size=>nil,
      :career_level=>nil},
    :non_primary_companies=>[{
      :name=>"AHP JHM",
      :url=>"http://www.meinunternehmen.de",
      :tag=>"AHPJHM",
      :title=>"Sekretär",
      :begin_date=>"2011-02",
      :end_date=>"2015-03",
      :description=>"PositionsBeschreibung",
      :industry=>"MINING_AND_METALS",
      :company_size=>"1-10",
      :career_level=>"ENTRY_LEVEL"},
      {:name=>"BAO",
      :url=>nil,
      :tag=>"BAO",
      :title=>"Mensch",
      :begin_date=>nil,
      :end_date=>nil,
      :description=>nil,
      :industry=>"BANKING",
      :company_size=>nil,
      :career_level=>"STUDENT_INTERN"}],
    :awards=>[{
      :url=>nil,
      :name=>"Nobelpreis",
      :date_awarded=>2012
      }]
    },
  :time_zone=>{:utc_offset=>1.0, :name=>"Europe/Berlin"},
  :wants=>"das suche ich",
  :web_profiles=>{
    :homepage=>["http://www.myhomepage.de"],
    :github=>["http://www.github.de"],
    :facebook=>["http://www.facebook.de/jonny123"]
    }
}



if(REQUEST)
  puts "Please open the following URL in your browser:"
  puts " https://dev.xing.com/applications"
  print "and enter the consumer key: "
  consumer_key = "4ec0fcd8b3f760c8dc92"

  print "enter the consumer secret here: "
  consumer_secret = "8a5af85a29a1c37df986b444be08119508e2d1aa"

  client = XingApi::Client.new(
    consumer_key: consumer_key,
    consumer_secret: consumer_secret
  )

  # Step 1: Obtain a request token
  # more info -> https://dev.xing.com/docs/authentication#call_v1_request_token
  puts "\nStarting oauth handshake, ask for request token..."
  request_token = client.get_request_token

  # Step 2: Obtain user authorization
  # more info -> https://dev.xing.com/docs/authentication#call_v1_authorize
  puts "\nPlease open the following URL in your browser:"
  puts "#{request_token[:authorize_url]}"
  print "\nand enter the PIN here: "
  verifier = gets.strip

  # Step 3: Exchange the authorized request token for an access token
  # more info -> https://dev.xing.com/docs/authentication#call_v1_access_token
  puts "\nExchanging request token for your access token..."
  access_token = client.get_access_token(verifier)



    userdata =  XingApi::User.me(client: client)[:users][0]
end

 usefull = {
    "birthday" => nil,
    "employment" => nil,
    "user_status" => nil,
    "languages" => [],
    "interests" => nil,
    "web_profiles"=> nil,
      "homepage" => nil,
      "github" => nil,
      "facebook" => nil,
    "xing" => nil,
    "praktika" => "",
    "jobs" => nil,
    "interests" => nil,
    "haves" => nil,
    "wants" => nil,
    "what_makes_me_special" => ""
  }
# puts UserStatus.where(:name => 'no interest').first.id
#Converting - Höchstwahrscheinlich aktualisieren!
usefull["birthday"] = "#{userdata[:birth_date][:year]}-#{userdata[:birth_date][:month]}-#{userdata[:birth_date][:day]}"
usefull["employment"] = userdata[:employment_status]
#usefull["user_status"] = (userdata[:employment]=="STUDENT") ? UserStatus.where(:name => 'jobseeking').first : (userdata[:employment_status]=="RETIRED" ? UserStatus.where(:name => 'no interest').first : UserStatus.where(:name => 'employed').first)

#userdata[:languages].each do |x| usefull["languages"] << [get_language_name(x["language"]["name"].downcase), get_skill_id(x["id"])] end

puts
userdata[:languages].each do|a, b| usefull["languages"] << [get_language_name(a.to_s), get_skill(b)] end


usefull["homepage"] = userdata[:web_profiles][:homepage] ? userdata[:web_profiles][:homepage][0] : nil
usefull["github"] = userdata[:web_profiles][:github] ? userdata[:web_profiles][:github][0] : nil
usefull["facebook"] = userdata[:web_profiles][:facebook] ? userdata[:web_profiles][:facebook][0] : nil
usefull["xing"]=userdata[:permalink]

#primary job
usefull["jobs"]= "By #{userdata[:professional_experience][:primary_company][:name]} as #{userdata[:professional_experience][:primary_company][:title]}".gsub(/\t/,' ')
usefull["jobs"] += (userdata[:professional_experience][:primary_company][:description] ? " (#{userdata[:professional_experience][:primary_company][:description]})": "").gsub(/\t/,' ')
#other jobs
userdata[:professional_experience][:non_primary_companies].each do |a|
  if(a[:career_level] != "STUDENT_INTERN")
  usefull["jobs"] += ", by #{a[:name]} as #{a[:title]}"
  usefull["jobs"] += (a[:description] ? " (#{a[:description]})": "")
  usefull["jobs"] += (a[:begin_date]&&a[:end_date] ? " from #{a[:begin_date]} until #{a[:end_date]}\n": "\n")
  else
  usefull["praktika"] += "#{a[:name]}: as #{a[:title]}"
  usefull["praktika"] += (a[:description] ? " (#{a[:description]})": "")
  usefull["praktika"] += (a[:begin_date]&&a[:end_date] ? " from #{a[:begin_date]} until #{a[:end_date]}\n": "\n")
end
end
usefull["interests"] = userdata[:interests]
usefull["haves"] = userdata[:haves]
usefull["wants"] = userdata[:wants]
userdata[:professional_experience][:awards].each do |a| usefull["what_makes_me_special"] += "#{a[:name]}" + (a[:date_awarded] ? " (#{a[:date_awarded]})" : "") end


puts usefull
