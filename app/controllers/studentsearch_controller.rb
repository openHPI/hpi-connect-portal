class StudentsearchController < ApplicationController
    def index
<<<<<<< HEAD
        result =[]
        if params.include? :q and params[:q] != ''
                @query = params[:q]
                param = "%#{@query.downcase}%"
                result = result + Student.searchStudent(param)
                #Optimierungspotiential Could catch empty querrystrings
                #Have not done this to provide better readable code 
        end

        if params.include?("Language")
            tmp = []
            params["Language"].each{
                |name|
                    result = (result &  Student.searchStudentsByLanguage(name.downcase))
            }
        end

        if params.include?("ProgrammingLanguage")
            params["ProgrammingLanguage"].each{
                |name|
                    result = (result & Student.searchStudentsByProgrammingLanguage(name.downcase))

            }
        end

        if params.include?:semester and params[:semester] != ''
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
=======
        @query = params[:q] || ""
        @no_search = @query.empty?
        if not @no_search
            param = "%#{@query.downcase}%"
            @students = Student.where("
                lower(first_name) LIKE ?
                OR lower(last_name) LIKE ?
                OR lower(academic_program) LIKE ?
                OR lower(education) LIKE ?
                OR lower(homepage) LIKE ?
                OR lower(github) LIKE ?
                OR lower(facebook) LIKE ?
                OR lower(xing) LIKE ?
                OR lower(linkedin) LIKE ?
                ", param, param, param, param, param, param, param, param, param).order("last_name, first_name")    
        else
            @students = []
        end

>>>>>>> origin/develop-js-student-profile
        
    end
end
