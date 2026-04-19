OpenAI.configure do |config|
  # config.access_token = Rails.application.credentials.openai[:api_key]
  # credentialsがない場合は環境変数にフォールバック
  config.access_token = Rails.application.credentials.dig(:openai, :api_key) ||
                        ENV["OPENAI_API_KEY"]
end
