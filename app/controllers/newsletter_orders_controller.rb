class NewsletterOrdersController < ApplicationController
  load_and_authorize_resource

  before_action :set_newsletter_order, only: [:delete]

  def destroy
    @newsletter_order.delete
    respond_and_redirect_to(job_offers_path, "Newsletter erfolgreich gelöscht")
  end

  def create
    NewsletterOrder.create!(student:current_user.manifestation, search_params: params[:newsletter_params])
    respond_and_redirect_to(job_offers_path, "Newsletter erfolgreich angelegt")
  end

  private
    def set_newsletter_order
      @newsletter_order = NewsletterOrder.find params[:id]
    end

end