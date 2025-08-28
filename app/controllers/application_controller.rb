class ApplicationController < ActionController::Base
  allow_browser versions: :modern
  before_action :require_login
  add_flash_types :success, :danger

  private
  def not_authenticated
    redirect_to login_path, danger: t("default.flash_message.require_login")
  end

  def block_focus_mode
    return unless current_user&.focus?
    redirect_to user_path(current_user.id), danger: t("default.flash_message.mode_block"), status: :see_other
  end
end
