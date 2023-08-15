OpenAI.configure do |config|
  config.access_token = ENV.fetch('OPENAI_API_KEY', nil)
  # config.organization_id = ENV.fetch('ORGANIZATION_ID')
end
