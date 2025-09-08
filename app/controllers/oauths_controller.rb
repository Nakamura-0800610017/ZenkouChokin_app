class OauthsController < ApplicationController
  skip_before_action :require_login, raise: false

  def oauth
    login_at(params[:provider])
  end

  def callback
    provider = params[:provider]
    if @user = login_from(provider)
      redirect_to root_path, success: t("oauths.login.success")
    else
      begin
        @user = create_from(provider)
        reset_session
        auto_login(@user)
        redirect_to root_path, success: t("oauths.login.success")
      rescue
        redirect_to root_path, danger: t("oauths.login.failed")
      end
    end
  end

  private
  def auth_params
    params.permit(:code, :provider)
  end
end
