class StudentsearchController < ApplicationController
    def index
        result = nil
        if params.include?(:q) and params[:q] != ''
                @query = params[:q]
                param = "%#{@query.downcase}%"
                result = User.search_student(param)
        end

        if params.include?("Language")
            params["Language"].each{
                |name|

                    if result
                        result = result & User.search_students_by_language(name)
                    else
                        result = User.search_students_by_language(name)
                    end
            }
        end

        if params.include?("ProgrammingLanguage")
            params["ProgrammingLanguage"].each{
                |name|
                    if result
                        result = result & User.search_students_by_programming_language(name)
                    else
                        result = User.search_students_by_programming_language(name)
                    end
            }
        end

        if params.include?(:semester) and params[:semester] != ''
            @semester = params[:semester]
            tmp = params[:semester]
                studentForSemester = []
                tmp = tmp.split(',')
                tmp.each{
                    |str|
                        int = str.to_i
                        if int > 0 and int < 20
                            student_for_semester = student_for_semester + User.where(semester: int)
                        end
                }
            if result    
                result = result & student_for_semester  
            else
                result = student_for_semester
            end
        end
        if not result
            @no_search = true
            @students = []
        else
            @no_search = false
            @students = result  
        end
    end
end
