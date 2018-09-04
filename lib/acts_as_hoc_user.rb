require "acts_as_hoc_user/version"
require "acts_as_hoc_user/configuration"
require "acts_as_hoc_user/acts_as_hoc_user"
module ActsAsHocUser
  LOCK = Mutex.new
  class << self
    def configure(config_hash=nil)
      if config_hash
        config_hash.each do |k,v|
          configuration.send("#{k}=", v) rescue nil if configuration.respond_to?("#{k}=")
        end
      end

      yield(configuration) if block_given?
    end

    def configuration
      @configuration = nil unless defined?(@configuration)
      @configuration || LOCK.synchronize { @configuration ||= ActsAsHocUser::Configuration.new }
    end
  end
end
