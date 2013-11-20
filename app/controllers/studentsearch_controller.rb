class StudentsearchController < ApplicationController
    def index
        result =[]
        if params.include?( :q) and params[:q] != ''
                @query = params[:q]
                param = "%#{@query.downcase}%"
                result = result + Student.searchStudent(param)
                #Optimierungspotiential Could catch empty querrystrings
                #Have not done this to provide better readable code 
        end

        if params.include?("Language")
            params["Language"].each{
                |name|
                    result = (result &  Student.searchStudentsByLanguage(name))
            }
        end

        if params.include?("ProgrammingLanguage")
            params["ProgrammingLanguage"].each{
                |name|
                    tmp = []
                    tmp =  Student.searchStudentsByProgrammingLanguage(name)
                    result = result & tmp
                    pp result
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
                            studentForSemester = studentForSemester +Student.where(semester: int)
                        end
                }
            result = result & studentForSemester  
        end
        @students = result        
    end
end
