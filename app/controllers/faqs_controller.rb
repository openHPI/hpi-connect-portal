class FaqsController < ApplicationController
  skip_before_filter :signed_in_user
  skip_before_filter :verify_authenticity_token
  before_action :set_faq, only: [:show, :edit, :update, :destroy]

  # GET /faqs
  # GET /faqs.json
  def index
    @faqs = Faq.all
  end

  # GET /faqs/new
  def new
    @faq = Faq.new
  end

  # GET /faqs/1/edit
  def edit
  end

  # POST /faqs
  # POST /faqs.json
  def create
    @faq = Faq.new(faq_params)

    if @faq.save
      redirect_to faqs_path
    else
      render_errors_and_action(@faq, 'new')
    end
  end

  # PATCH/PUT /faqs/1
  # PATCH/PUT /faqs/1.json
  def update
    if @faq.update(faq_params)
      redirect_to faqs_path
    else
      render_errors_and_action(@faq, 'edit')
    end
  end

  # DELETE /faqs/1
  # DELETE /faqs/1.json
  def destroy
    @faq.destroy
    respond_and_redirect_to(faqs_url, 'FAQ has been successfully deleted.')
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_faq
      @faq = Faq.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def faq_params
      params.require(:faq).permit(
        :question, :answer, :locale)
    end
end
