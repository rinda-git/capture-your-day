require "resend"

resend_api_key = ENV["RESEND_API_KEY"]

if resend_api_key.present?
  Resend.api_key = resend_api_key
elsif Rails.env.production?
  raise KeyError, "key not found: \"RESEND_API_KEY\""
end
