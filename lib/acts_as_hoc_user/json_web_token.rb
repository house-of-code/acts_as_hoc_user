require 'jwt'
module ActsAsHocUser
  class JsonWebToken
    class << self
      def encode(payload, exp = 48.hours.from_now)
        payload[:exp] = exp.to_i
        JWT.encode(payload, ActsAsHocUser.configuration.acts_as_hoc_user_secret)
      end

      def decode(token)
        body = JWT.decode(token, ActsAsHocUser.configuration.acts_as_hoc_user_secret)[0]
        HashWithIndifferentAccess.new body
      rescue
        nil
      end
    end
  end
end
