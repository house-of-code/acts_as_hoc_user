module ActsAsHocUser
  class Configuration
    attr_accessor :min_password_length
    def initialize
      @min_password_length = 6
    end
  end
end
