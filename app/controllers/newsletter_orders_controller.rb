# == Schema Information
#
# Table name: newsletter_orders
#
#  id            :integer          not null, primary key
#  student_id    :integer
#  search_params :text
#  created_at    :datetime
#  updated_at    :datetime
#

class NewsletterOrdersController < ApplicationController
  load_and_authorize_resource

  before_action :set_newsletter_order, only: [:destroy, :show]

  def new
    @newsletter_params = newsletter_params
  end

  def show
  end

  def destroy
    @newsletter_order.delete
    respond_and_redirect_to(job_offers_path, "Newsletter erfolgreich gelöscht")
  end

  def create
    NewsletterOrder.create!(student:current_user.manifestation, search_params: newsletter_params.to_h)
    respond_and_redirect_to(job_offers_path, "Newsletter erfolgreich angelegt")
  end

  private
    def set_newsletter_order
      @newsletter_order = NewsletterOrder.find params[:id]
    end

    def newsletter_params
      params.permit(newsletter_params: [:active, :employer, :category, :graduation, :state, :student_group, :start_date, :end_date, :time_effort, :compensation])[:newsletter_params]
    end

end
