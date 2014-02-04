class UsersController < ApplicationController

  def show
    user = User.find params[:id]
    if can? :read, user 
      if user.student?
        redirect_to student_path user and return
      elsif user.staff?
        redirect_to staff_path user and return
      end
    end
    redirect_to root_path
  end

  def userlist
    user = User.find(params[:exclude_user])
    unless can? :promote, user
      respond_to do |format|
        format.json { render json: { is_deputy: false, users: nil } }
      end
      return
    end

    is_deputy = user.deputy?
    is_deputy = (is_deputy == nil) ? false : is_deputy
    users = nil
    if is_deputy
      students = User.where(role: Role.find_by_level(1))
      staff_of_employer = User.where(role: Role.find_by_level(2), employer: user.employer).where.not(id: user.id)
      users = students + staff_of_employer
      users.sort! {|a,b| a.lastname.downcase <=> b.lastname.downcase}
    end
    respond_to do |format|
      format.json { render json: { is_deputy: is_deputy, users: users.as_json(only: :id, methods: :full_name) } }
    end
  end

end
