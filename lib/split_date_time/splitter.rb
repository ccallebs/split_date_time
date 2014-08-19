require 'active_record'
require 'active_support/all'
# require 'version'

module SplitDateTime
  module Splitter
    extend ActiveSupport::Concern

    class Naming
      def self.time_getter(field, prefix = nil)
        "#{prefix_or_field(field, prefix)}_time"
      end

      def self.time_setter(field, prefix = nil)
        "#{prefix_or_field(field, prefix)}_time="
      end

      def self.date_getter(field, prefix = nil)
        "#{prefix_or_field(field, prefix)}_date"
      end

      def self.date_setter(field, prefix = nil)
        "#{prefix_or_field(field, prefix)}_date="
      end

      def self.prefix_or_field(field, prefix = nil)
        prefix.present? ? "#{prefix}" : "#{field}"
      end
    end

    included do
      extend ClassMethods
    end

    module ClassMethods
      def split_date_time(field, options = {})
        define_split_accessors(field, options[:prefix], options[:date_format], options[:time_format])
        define_concatenation_callback(field, options[:prefix])
      end

      def define_split_accessors(field, prefix = nil, date_format = nil, time_format = nil)
        time_format ||= '%H:%M'
        date_format ||= '%m/%d/%Y'

        define_method Naming.time_getter(field, prefix) do
          field_val = send(field)
          field_val.strftime(time_format) if field_val.present?
        end
        define_method Naming.time_setter(field, prefix) do |val|
          instance_variable_set :"@#{Naming.time_getter(field, prefix)}", val
        end
        define_method Naming.date_getter(field, prefix) do
          field_val = send(field)
          field_val.strftime(date_format) if field_val.present?
        end
        define_method Naming.date_setter(field, prefix) do |val|
          instance_variable_set :"@#{Naming.date_getter(field, prefix)}", val
        end
      end

      def define_concatenation_callback(field, prefix)
        if self.kind_of? ActiveRecord::Base
          before_validation :"concatenate_#{field}", if: :"#{field}_modified?"
        end

        define_method :"concatenate_#{field}" do
          time_variable = instance_variable_get(:"@#{Naming.time_getter(field, prefix)}")
          time_variable ||= send("#{Naming.time_getter(field, prefix)}")
          date_variable = instance_variable_get(:"@#{Naming.date_getter(field, prefix)}")
          date_variable ||= send("#{Naming.date_getter(field, prefix)}")
          self.send "#{field}=", DateTime.parse("#{date_variable} #{time_variable}")
        end

        define_method :"#{field}_modified?" do
          time_variable = instance_variable_get(:"@#{Naming.time_getter(field, prefix)}")
          date_variable = instance_variable_get(:"@#{Naming.date_getter(field, prefix)}")
          time_variable.present? || date_variable.present?
        end
      end
    end
  end
end
