class StudentsearchController < ApplicationController
    def index
        @query = params[:q]
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
    end
end
