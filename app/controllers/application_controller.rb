class ApplicationController < ActionController::Base
  allow_browser versions: :modern
  before_action :require_login
  add_flash_types :success, :danger

  private
  def not_authenticated
    redirect_to login_path, danger: t("default.flash_message.require_login")
  end
end
