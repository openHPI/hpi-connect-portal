class CertificateController < ApplicationController

  before_action :set_certificate, only: [:destroy]

  def destroy
    if @certificate.destroy
      respond_and_redirect_to(:back, I18n.t('certificates.messages.successfully_deleted'))
    else
      render_errors_and_action(@certificate, 'destroy')
      end
  end

  private
  def set_certificate
    @certificate = Certificate.find params[:id]
  end
end
