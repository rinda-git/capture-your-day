require 'rails_helper'

RSpec.describe "Favorites", type: :request do
  let(:user) { create(:user) }
  let(:mistake) { create(:mistake, user: user) }
  # ☆ 保存から保存済みに置き換える返事
  let(:turbo_stream_headers) { { "ACCEPT" => "text/vnd.turbo-stream.html" } }

  before do
    sign_in user
  end

  describe "POST /create" do
    it "returns http success" do
      post "/favorites",
            params: { mistake_id: mistake.id },
            headers: turbo_stream_headers

      expect(response).to have_http_status(:success)
    end
  end

  describe "DELETE /destroy" do
    it "returns http success" do
      delete "/favorites",
              params: { mistake_id: mistake.id },
              headers: turbo_stream_headers

      expect(response).to have_http_status(:success)
    end
  end
end
