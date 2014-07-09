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
    require 'csv'
    if params[:alumni_file].present?
      count, errors = 0, []
      CSV.foreach(params[:alumni_file].path, headers: true, header_converters: :symbol) do |row|
        count += 1
        alumni = Alumni.create_from_row row
        errors << alumni.errors.full_messages.first + '(' + count.to_s + ')' unless alumni == :created
      end
      if errors.any?
        notice = { error: "The following lines (starting from 1) contain errors: " + errors.join(", ")}
      else
        notice = "Users have been imported!"
      end
    end
    respond_and_redirect_to alumni_new_path, notice
  end

  private

    def alumni_params
      params.require(:alumni).permit(:firstname, :lastname, :email, :alumni_email)
    end
end
