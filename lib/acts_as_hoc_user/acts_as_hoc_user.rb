  require_relative 'json_web_token'

  module ActsAsHocUser
    extend ActiveSupport::Concern
    included do
    end

    def authentication_token(expiration = 14.days.from_now)
      JsonWebToken.encode({ user_id: id }, expiration)
    end

    module ClassMethods
      def authenticate_with_credentials(email, password, expiration = 14.days.from_now)
        user = User.find_by(email:email)
        return nil if user.nil?
        return user.authentication_token(expiration) if user.authenticate(password)
        nil
      end

      def authenticate_with_sso_token(token)
        user = User.find_by(sso_token: token)
        return nil if user.nil?
        return user.authentication_token(expiration)
      end
      
      def authenticate_with_authentication_token(token)
        decoded_auth_token = JsonWebToken.decode(token)
        return nil if decoded_auth_token.nil?
        user = User.find(decoded_auth_token[:user_id])
        return user
      end

      def authenticate_with_http_headers(headers = {})
        if headers['Authorization'].present?
          return authenticate_with_authentication_token(headers['Authorization'].split(' ').last)
        end
        return nil
      end

      def acts_as_hoc_user(_options = {})
        has_secure_password
        validates_presence_of :email
        validates :email, uniqueness: true, format: { with: URI::MailTo::EMAIL_REGEXP }
        validates :password, length: { minimum: ActsAsHocUser.configuration.min_password_length }, if: -> { password.present? }
      end
    end
  end
  ActiveRecord::Base.send :include, ActsAsHocUser
