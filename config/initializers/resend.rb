require "resend"

resend_api_key = ENV["RESEND_API_KEY"]

if ENV["RESEND_API_KEY"].present?
  Resend.api_key = ENV["RESEND_API_KEY"]
end
