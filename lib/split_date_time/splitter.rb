require 'active_record'
require 'active_support/all'
# require 'version'

module SplitDateTime
  module Splitter
    extend ActiveSupport::Concern

    included do
      extend ClassMethods
    end

    module ClassMethods
      def split_date_time(options = {})
        options[:prefix] ||= options[:field]
        define_split_accessors(options[:field], options[:prefix])
        define_concatenation_callback(options[:field], options[:prefix])
      end

      def define_split_accessors(field, prefix)
        define_method :"#{prefix}_time" do
          field_val = send(field)
          field_val.strftime('%H:%M') if field_val.present?
        end
        define_method :"#{prefix}_time=" do |val|
          instance_variable_set :"@#{prefix}_time", val
        end
        define_method :"#{prefix}_date" do
          field_val = send(field)
          field_val.strftime('%m/%d/%Y') if field_val.present?
        end
        define_method :"#{prefix}_date=" do |val|
          instance_variable_set :"@#{prefix}_date", val
        end
      end

      def define_concatenation_callback(field, prefix)
        before_save :"concatenate_#{field}"
        define_method :"concatenate_#{field}" do
          Time do
            date_val = instance_variable_get :"@#{prefix}_date"
            time_val = instance_variable_get :"@#{prefix}_time"
            self.send "#{field}=", Time.parse("#{date_val} #{time_val}")
          end
        end
      end
    end
  end
end
