require 'rails/generators/active_record'
module ActsAsHocUser
  #module Generators
    class HocUserGenerator < ActiveRecord::Generators::Base

      desc "Create a HocUser model and migrations " +
      "The NAME argument is the name of your model, and the following " +
      "arguments are the fields to add. Eg. acts_as_hoc_user:hoc_user user name:string:index"

      argument :fields, :required => false, :type => :array, :desc => "The fields to add.",
      :banner => "name:string:index age:integer ..."

      def self.source_root
        @source_root ||= File.expand_path('../templates', __FILE__)
      end


      def generate_migration
        template "initializer.rb", "config/initializers/acts_as_hoc_user.rb"
        template "hoc_user.rb.erb", "app/models/#{model_name}.rb"
        migration_template("create_hoc_user.rb.erb",
          "db/migrate/#{migration_file_name}",
          migration_version: migration_version)
      end

      def model_name
        name.underscore
      end

      def migration_colums
        return fields.map { |field| "t.#{field.split(":").second} :#{field.split(":").first}" } unless fields.nil?
        return []
      end

      def migration_indexes
        return fields.map { |field|
          elems = field.split(":")
          elems.first if elems.count > 2
        }.compact unless fields.nil?
        return []
      end

      def model_class_name
        name.camelize
      end

      def migration_name
        "create_#{name.underscore.pluralize}"
      end

      def migration_file_name
        "#{migration_name}.rb"
      end

      def migration_class_name
        migration_name.camelize
      end

      def migration_version
        if Rails.version.start_with? "5"
          "[#{Rails::VERSION::MAJOR}.#{Rails::VERSION::MINOR}]"
        end
      end
    end
  #end
end
