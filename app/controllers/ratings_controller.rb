# == Schema Information
#
# Table name: ratings
#
#  id                      :integer          not null, primary key
#  student_id              :integer
#  employer_id             :integer
#  job_offer_id            :integer
#  headline                :string(255)
#  description             :text
#  score_overall           :integer
#  score_atmosphere        :integer
#  score_salary            :integer
#  score_work_life_balance :integer
#  score_work_contents     :integer
#

class RatingsController < ApplicationController

  before_action :set_ratings_for_index
  before_action :set_employer, only: [:new, :create, :edit, :update, :index]
  before_action :set_job_offers_selection, only: [:new, :create, :edit, :update]

  load_and_authorize_resource
  skip_load_resource only: [:create]

  def index
  end

  def new
  end

  def create
    @rating = Rating.new(rating_params)
    @rating.student_id = current_user.manifestation_id
    @rating.employer_id = params[:employer_id]

    if @rating.save
      flash[:success] = I18n.t('ratings.messages.successfully_created')
      redirect_to employer_ratings_path
    else
      render_errors_and_action(@rating, 'new')
    end
  end

  def edit
  end

  def update

    if @rating.update(rating_params)
      flash[:success] = I18n.t('ratings.messages.successfully_updated')
      redirect_to employer_ratings_path
    else
      render_errors_and_action(@rating, 'edit')
    end
  end

  def destroy
    @rating.destroy

    redirect_to employer_ratings_path
  end

  private
    def rating_params
      params.require(:rating).permit(:job_offer_id, :headline, :description, :score_overall, :score_atmosphere, :score_salary, :score_work_life_balance, :score_work_contents)
    end

    def set_ratings_for_index
      @ratings = Rating.where(employer_id: params[:employer_id]).paginate(page: params[:page])
    end

    def set_employer
      @employer = Employer.find(params[:employer_id])
    end

    def set_job_offers_selection
      @selectable_job_offers = JobOffer.where(employer_id: params[:employer_id])
    end
end
