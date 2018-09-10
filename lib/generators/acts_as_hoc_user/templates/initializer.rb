ActsAsHocUser.configure do |config|
  config.min_password_length = 6
  config.acts_as_hoc_user_secret = "replace me"
end
