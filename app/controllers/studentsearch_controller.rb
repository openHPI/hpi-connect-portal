class StudentsearchController < ApplicationController
  def index
    @students = []
    
    @query = params[:q] || ''
    if @query != ''
      @students = User.search_student("%#{@query.downcase}%")
    end
    
    @students = @students.concat(find_and_add_users(params["Language"], :languages)).uniq {|s| s.id}
    @students = @students.concat(find_and_add_users(params["ProgrammingLanguage"], :programming_languages)).uniq {|s| s.id}
    
    @semester = params[:semester] || ''
    @students = @students.concat(User.where("semester IN (?)", @semester.split(',').map(&:to_i))).uniq {|s| s.id}

    @no_search = @students.length == 0
  end


  private

    def find_and_add_users(names, language_identifier)
      res = []
      if names.nil?
        return res
      end

      names.each do |name|
        res.concat(User.search_students_by_language_identifier(language_identifier, name))
      end

      return res
    end
end
