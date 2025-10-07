require 'rails_helper'

RSpec.describe 'Xアカウントでの外部認証', type: :system do
  let(:provider) { 'twitter' }
  let(:user)     { create(:user) }

  it '既存ユーザーはXでログインできる' do
    allow_any_instance_of(OauthsController)
    .to receive(:login_from).with(provider) { |ctrl|
      ctrl.auto_login(user)
      user
    }
    visit "/oauth/callback?provider=#{provider}"

    expect(page).to have_current_path(root_path)
    expect(page).to have_content('Xアカウントでログインしました')
    expect(page).to have_button('ログアウト')
  end

  it '初回ログインはユーザーを作成してログインできる' do
    allow_any_instance_of(OauthsController)
      .to receive(:login_from).with(provider).and_return(nil)
    allow_any_instance_of(OauthsController)
      .to receive(:create_from).with(provider).and_return(user)

    visit "/oauth/callback?provider=#{provider}"

    expect(page).to have_current_path(root_path)
    expect(page).to have_content('Xアカウントでログインしました')
    expect(page).to have_button('ログアウト')
  end

  it 'プロバイダ側エラー等で失敗した場合はエラーフラッシュ' do
    allow_any_instance_of(OauthsController)
      .to receive(:login_from).with(provider).and_return(nil)
    allow_any_instance_of(OauthsController)
      .to receive(:create_from).with(provider).and_raise(StandardError)

    visit "/oauth/callback?provider=#{provider}"

    expect(page).to have_current_path(root_path)
    expect(page).to have_content('Xアカウントでのログインに失敗しました')
  end
end
