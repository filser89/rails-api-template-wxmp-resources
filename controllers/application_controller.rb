class ApplicationController < ActionController::API
  # skip_before_action :verify_authenticity_token
  before_action :set_locale
  USERS_PER_PAGE  = 20.freeze
  # respond_to :json

  private
  def per_param
    params[:per] || USERS_PER_PAGE
  end

  def offset_param
    return 0 unless params[:page].present?
    params[:page].to_i * USERS_PER_PAGE
  end

  def set_locale
    I18n.locale = params[:locale] || session[:locale] || I18n.default_locale

    if request.headers['X-API-Lang'].present? && request.headers['X-API-Lang'].to_sym.in?(I18n.available_locales)
      I18n.locale = request.headers['X-API-Lang']
    end
    session[:locale] = I18n.locale
  end
end
