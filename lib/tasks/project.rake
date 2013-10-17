require 'highline/import'

namespace :project do
  desc "register yourself for the swt2 project with your github username and your immatriculation number"
  task "register" => [:spec] do
    say "Tests ran successfully. Congratulations! Now please register yourself for the project."
    say_line    
    github_username = get_github_username()
    
    unless github_username.nil?
      say_line
      codeschool_account_number = ask("Please enter your Codeschool Account Id.: ", Integer){|q| q.in = 100000..9999999}      
      register(github_username, codeschool_account_number)
    end
  end
  
  def get_github_username()
    github_user = `git config --get user.name`
    github_user.strip!
    choose do |menu|
      menu.prompt = "Is '#{github_user}' your github username? "
      menu.choice("yes") { return github_user }
      menu.choice("no") { 
        say_warning
        return nil
      }
    end
  end
  
  def say_warning
    say("Please set your git username to match your github account (<%= color('git config user.name \"<github account>\"', BOLD) %>)!")
  end
  
  def register(github_name, codeschool_account_number)
    mat_nr = ask("Please enter your Mat-Nr.: ", Integer){|q| q.in = 100000..999999}
    begin
      resp = RestClient.post(server_address, assignment_hash(github_name, mat_nr, codeschool_account_number), {:accept => :json})
      say(JSON.parse(resp.body)["message"])      
    rescue => e
      if e.response.code == 409
        json = JSON.parse(e.response.body)
        say(json["message"])
        say_line
        choose do |menu|
          menu.prompt = "Overwrite existing record?"
          menu.choice("yes") {
            resp = RestClient.put(json["redirect_url"], assignment_hash(github_name, mat_nr, codeschool_account_number), {:accept => :json})
            say(JSON.parse(resp.body)["message"])
          }
          menu.choice("no") {return}
        end
      else
        puts e.response
      end
    end
  end
  
  def server_address()
    "http://192.168.30.32:3000/assignments"
  end
  
  def say_line
    say("------------------")
  end
  
  def assignment_hash(github_name, mat_nr, codeschool_account_number)
    {:assignment => {:github_account => github_name, :mat_nr => mat_nr, :code_school_account => codeschool_account_number}}
  end
end
