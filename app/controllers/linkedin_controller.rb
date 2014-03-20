require 'rubygems'
require 'linkedin'

class LinkedinController < ApplicationController
 
def get_language_name(n)
  case n
  when "englisch"
    return "english"
  when "deutsch"
    return "german"
  when "spanisch"
    return "spanish"
  when "französisch"
    return "french"
  when "chinesisch"
    return "chinese"  
  when "portugiesisch"
    return "portuguese"
  when "italienisch"
    return "italian"
  when "russisch"
    return "russian"
  when "polnisch"
    return "polish"
  when "schwedisch"
    return "swedish"
  when "finnisch"
    return "finnish"
  else
    return n
  end
end

def get_skill_id(linked_in_skill)
  case linked_in_skill
  when 4      
    return 4
  else
    return 6 - linked_in_skill  
  end
end

def init_client
  key = "77sfagfnu662bn"
  secret = "7HEaILeWfmauzlKp"
  linkedin_configuration = { :site => 'https://api.linkedin.com',
  :authorize_path => '/uas/oauth/authenticate',
  :request_token_path =>'/uas/oauth/requestToken?scope=r_basicprofile+r_fullprofile',
  :access_token_path => '/uas/oauth/accessToken' }
  @linkedin_client = LinkedIn::Client.new(key, secret,linkedin_configuration )
end
 
def auth
  init_client
  request_token = @linkedin_client.request_token(:oauth_callback => "http://#{request.host_with_port}/linkedin/callback/#{params[:id]}")
  session[:rtoken] = request_token.token
  session[:rsecret] = request_token.secret
  redirect_to @linkedin_client.request_token.authorize_url
end
 
def callback
  init_client
  if session[:atoken].nil?
    pin = params[:oauth_verifier]
    atoken, asecret = @linkedin_client.authorize_from_request(session[:rtoken], session[:rsecret], pin)
    session[:atoken] = atoken
    session[:asecret] = asecret
  else
    @linkedin_client.authorize_from_access(session[:atoken], session[:asecret])
  end
 
  c = @linkedin_client
  
  userdata = c.profile(:fields=>["summary", "specialties", "picture-url", "public_profile_url", "languages", "skills", "honors-awards", "courses", "three_current_positions", "three_past_positions", "date-of-birth", "interests", "volunteer", "current-status"])
 
  puts "profile_1 = #{userdata}"

usefull = {
    "birthday" => nil,            #birthday
    "user_status" => "jobseeking", #three_past_positions
    "languages" => [],            #languages
    "linkedin" => nil,            #public_profile_url
    "jobs" => "",                 #three_past_positions
    "interests" => nil,           #interests
    "haves" => "My Skills: ",     #skills, courses
    "what_makes_me_special" => "" #certifications, honors-awards, volunteer
  }
  
  usefull["birthday"] = "#{userdata["date-of-birth"][:year]}-#{userdata["date-of-birth"][:month]}-#{userdata["date-of-birth"][:day]}"

  usefull["interests"] = " interests: #{userdata["interests"]} summary: #{userdata["summary"]}"

  usefull["linkedin"] = userdata["public_profile_url"]

  userdata["skills"]["all"].each do |x| usefull["haves"] += "#{x["skill"]["name"]} " end
  if(userdata["courses"]["all"]) 
      usefull["haves"]+="My courses:" 
      userdata["courses"]["all"].each do |x| usefull["haves"] += " #{x["name"]}" end
  end

  userdata[:languages][:all].each do |x| usefull["languages"] << [get_language_name(x["language"]["name"].downcase), get_skill_id(x["id"])] end


  if(userdata["three_current_positions"])
    usefull["user_status"] = "employed but still looking"
    userdata["three_current_positions"]["all"].each do |x|  
    usefull["jobs"] += "I'm working since #{x["start_date"]["month"]}-#{x["start_date"]["year"]} in #{x["company"]["name"]} as #{x["title"]} (#{x["summary"]}}|"   
      
    end
  end
  

  userdata["three_past_positions"]["all"].each do |x|     
    usefull["jobs"] += "I've worked from #{x["start_date"]["month"]}-#{x["start_date"]["year"]} until #{x["end_date"]["month"]}-#{x["end_date"]["year"]} in #{x["company"]["name"]} as #{x["title"]} (#{x["summary"]}}|"   
  end

if userdata["honors-awards"]
  usefull["what_makes_me_special"] += "My awards: "
  userdata["honors-awards"]["all"].each do |a| usefull["what_makes_me_special"] += "#{a["name"]} " end
end
if(userdata["volunteer"])
 usefull["what_makes_me_special"] += "My experience as volunteer: " 
 userdata["volunteer"]["volunteer_experiences"]["all"].each do |v| usefull["what_makes_me_special"] += "I worked in #{v["organization"]["name"]} as #{v["role"]}" end
end

puts "das ist bis jetzt evaluiert: #{usefull}"







  usefull["languages"].each do |x,y| 
    if(Language.where(name: get_language_name(x)).count == 0)
      puts "#{x} does not exist in our database"
    else
      lang_id = Language.where(name: get_language_name(x)).first.id
      if(LanguagesUser.where(user_id: params[:id], language_id: lang_id).count == 0)  #create new entry
        LanguagesUser.create(user_id: params[:id], language_id: lang_id, skill: y)
      else #update entry
        LanguagesUser.where(user_id: params[:id], language_id: lang_id).first.update(skill: y)
      end
    end
  end


User.find_by_id("#{params[:id]}").update(birthday: usefull["birthday"])

User.find_by_id("#{params[:id]}").update(user_status_id: UserStatus.find_by_name(usefull["user_status"]).id)

User.find_by_id("#{params[:id]}").update(additional_information: "My interests: #{usefull["interests"]}|My jobs: #{usefull["jobs"]}|haves: #{usefull["haves"]}|wants: #{usefull["wants"]}|special: #{usefull["what_makes_me_special"]}")

User.find_by_id("#{params[:id]}").update(linkedin: usefull["linkedin"])

puts "hhh}|"
puts userdata["current-status"]
puts userdata["summary"]
puts  usefull 
 
  session[:atoken] = nil
  session[:asecret] = nil
  redirect_to root_path(:imported_from_linkedin=>"success")
end
 
end