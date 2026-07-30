require 'rails_helper'

RSpec.describe "NotificationSettings", type: :request do
  let(:user) { create(:user) }

  before do
    sign_in user
  end

  describe "GET /show" do
    it "returns http success" do
      get "/notification_setting"
      expect(response).to have_http_status(:success)
    end
  end

  describe 'PATCH/notification_setting' do

    it '通知をOFFに更新できる' do
      setting = create(
        :notification_setting,
        user: user,
        reminder_enabled: true,
        notification_time: "21:00"
      )

      expect {
        patch "/notification_setting",
             params: {
               notification_setting: {
                 reminder_enabled: "0",
                 notification_time: "21:00"
               }
              }
            }.to change {
                setting.reload.reminder_enabled
            }.from(true).to(false)

        expect(response).to redirect_to(notification_setting_path)
    end

    it '通知ONで時刻が空の場合は更新できない' do
      setting = create(
        :notification_setting,
        user: user,
        reminder_enabled: false,
        notification_time: nil
      )

      patch "/notification_setting",
           params: {
             notification_setting: {
               reminder_enabled: "1",
               notification_time: ""
             }
           }
    
    expect(response).to have_http_status(:unprocessable_entity)
    expect(setting.reload.reminder_enabled).to be(false)
    expect(setting.notification_time).to be_nil
    end
  end
end
