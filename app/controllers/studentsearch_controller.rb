class StudentsearchController < ApplicationController
    def index
        @students = []
        if params.include?(:q) and params[:q] != ''
                @query = params[:q]
                param = "%#{@query.downcase}%"
                @students = User.search_student(param)
        end

        @students = @students.concat(find_and_add_users(params["Language"], User.method(:search_students_by_language))).uniq {|s| s.id}
        @students = @students.concat(find_and_add_users(params["ProgrammingLanguage"], User.method(:search_students_by_programming_language))).uniq {|s| s.id}
        

        if params.include?(:semester) and params[:semester] != ''
            @semester = params[:semester]

            # possibly vulnerable to sql injection!
            @students = @students.concat(User.where("semester IN (?)", @semester.split(',').map(&:to_i))).uniq {|s| s.id}
            
        end

        @no_search = @students.length == 0
    end


    private

        def find_and_add_users(names, function)
            res = []
            if names.nil?
                return res
            end

            names.each do |name|
                res.concat(function.call(name))
            end

            return res
        end
end
