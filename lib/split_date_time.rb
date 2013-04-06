require 'active_record'
require 'split_date_time/version'

module SplitDateTime
  extend ActiveSupport::Concern

  included do
    extend ClassMethods
    before_save :concatenate_datetime
  end

  module ClassMethods
    def split_date_time(options = {})
      options[:alias] ||= options[:field]
      define_split_accessors(options[:field], options[:alias])
      define_concatenation_callback(options[:field], options[:alias])
    end

    def define_split_accessors(field, alias_name)
      define_method :"#{alias_name}_time" do 
        field_val = send(field)
        I18n.l(field_val, format: :js_time) if field_val
      end
      define_method :"#{alias_name}_time=" do |val|
        instance_variable_set :"@#{alias_name}_time", val
      end
      define_method :"#{alias_name}_date" do 
        field_val = send(field)
        I18n.l(field_val, format: :js_date) if field_val
      end
      define_method :"#{alias_name}_date=" do |val|
        instance_variable_set :"@#{alias_name}_date", val
      end
    end

    def define_concatenation_callback(field, alias_name)
      define_method :concatenate_datetime do 
        Time.use_zone(timezone) do 
          date_val = instance_variable_get :"@#{alias_name}_date"
          time_val = instance_variable_get :"@#{alias_name}_time"
          self.send "#{field}=", Time.zone.parse("#{date_val} #{time_val}")
        end   
      end
    end
  end
end

ActiveRecord::Base.extend SplitDateTime