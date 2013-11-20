class StudentsearchController < ApplicationController
    def index
        result = nil
        if params.include?( :q) and params[:q] != ''
                @query = params[:q]
                param = "%#{@query.downcase}%"
                result = Student.searchStudent(param)
                #Optimierungspotiential Could catch empty querrystrings
                #Have not done this to provide better readable code 
        end

        if params.include?("Language")
            params["Language"].each{
                |name|

                    if result
                        result = (result &  Student.searchStudentsByLanguage(name))        
                    else
                        result = Student.searchStudentsByLanguage(name)
                    end
            }
        end

        if params.include?("ProgrammingLanguage")
            params["ProgrammingLanguage"].each{
                |name|
                    if result
                        result = result & Student.searchStudentsByProgrammingLanguage(name)
                    else
                        result = Student.searchStudentsByProgrammingLanguage(name)
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
                            studentForSemester = studentForSemester + Student.where(semester: int)
                        end
                }
            if result    
                result = result & studentForSemester  
            else
                result = studentForSemester
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
