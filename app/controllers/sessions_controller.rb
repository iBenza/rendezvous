class SessionsController < Devise::SessionsController
  before_action :configure_sign_in_params
  skip_before_action :redirect_unless_signed_in

  def new
    if user_signed_in?
      redirect_to flow_path, status: 301
    else
      super
    end
  end

  protected

  def configure_sign_in_params
    devise_parameter_sanitizer.for(:sign_in) << :name
  end
end
