class AlumniController < ApplicationController
  authorize_resource

  def new
    @alumni = Alumni.new
  end

  def create
    alumni = Alumni.create_from_row alumni_params
    if alumni == :created
      respond_and_redirect_to alumni_new_path, 'Alumni erfolgreich erstellt!' 
    else
      @alumni = alumni
      render 'new'
    end
  end

  def create_from_csv
    # require 'csv'
    if params[:alumni_file].present?
      count, errors = 0, []
      CSV.foreach(params[:alumni_file].path, headers: true, header_converters: :symbol) do |row|
        count += 1
        alumni = Alumni.create_from_row row
        errors << alumni.errors.full_messages.first + '(' + count.to_s + ')' unless alumni == :created
      end
      if errors.any?
        notice = { error: 'The following lines (starting from 1) contain errors: ' + errors.join(', ')}
      else
        notice = 'Alumni erfolgreich importiert!'
      end
    end
    respond_and_redirect_to alumni_new_path, notice
  end

  def register
    @alumni = Alumni.find_by_token params[:token]
  end

  def link
    alumni = Alumni.find_by_token params[:token]
    user = User.find_by_email params[:session][:email]
    if user && user.authenticate(params[:session][:password])
      alumni.link user
      sign_in user
      respond_and_redirect_to user.manifestation, 'Alumni-Email erfolgreich hinzugefügt!'
    else
      flash[:error] = 'Invalid email/password combination'
      redirect_to alumni_email_path(token: params[:token])
    end
  end

  def link_new
    @alumni = Alumni.find_by_token params[:token]
    user = User.new link_params
    user.manifestation = Student.new
    if user.save
      @alumni.link user
      sign_in user
      respond_and_redirect_to [:edit, user.manifestation], I18n.t('users.messages.successfully_created')
    else
      render 'register'
    end
  end

  private

    def alumni_params
      params.require(:alumni).permit(:firstname, :lastname, :email, :alumni_email)
    end

    def link_params
      params.require(:user).permit(:firstname, :lastname, :email, :password, :password_confirmation)
    end
end
