class StudentsearchController < ApplicationController
    def index
        @students = []
        if params.include?(:q) and params[:q] != ''
                @query = params[:q]
                param = "%#{@query.downcase}%"
                @students = User.search_student(param)
        end

        if params.include?("Language")
            @students = @students.concat(find_and_add_users(params["Language"], User.method(:search_students_by_language))).uniq {|s| s.id}
        end

        if params.include?("ProgrammingLanguage")
            @students = @students.concat(find_and_add_users(params["ProgrammingLanguage"], User.method(:search_students_by_programming_language))).uniq {|s| s.id}
        end

        if params.include?(:semester) and params[:semester] != ''
            @semester = params[:semester]
            tmp = params[:semester]
                student_for_semester = []
                tmp = tmp.split(',')
                tmp.each do
                    |str|
                        int = str.to_i
                        if int > 0 and int < 20
                            student_for_semester = student_for_semester + User.where(semester: int)
                        end
                end

            
            @students = @students.concat(student_for_semester).uniq {|s| s.id}
            
        end

        if @students.length == 0
            @no_search = true
        else
            @no_search = false  
        end
    end


    private

        def find_and_add_users(names, function)
            res = []
            names.each do |name|
                res.concat(function.call(name))
            end

            return res
        end
end
