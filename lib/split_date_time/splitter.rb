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
        define_split_accessors(field, options[:prefix])
        define_concatenation_callback(field, options[:prefix])
      end

      def define_split_accessors(field, prefix = nil)
        define_method Naming.time_getter(field, prefix) do
          field_val = send(field)
          field_val.strftime('%H:%M') if field_val.present?
        end
        define_method Naming.time_setter(field, prefix) do |val|
          instance_variable_set :"@#{Naming.time_getter(field, prefix)}", val
        end
        define_method Naming.date_getter(field, prefix) do
          field_val = send(field)
          field_val.strftime('%m/%d/%Y') if field_val.present?
        end
        define_method Naming.date_setter(field, prefix) do |val|
          instance_variable_set :"@#{Naming.date_getter(field, prefix)}", val
        end
      end

      def define_concatenation_callback(field, prefix)
        if self.kind_of? ActiveRecord::Base
          before_save :"concatenate_#{field}"
        end

        define_method :"concatenate_#{field}" do
          date_val = instance_variable_get :"@#{Naming.date_getter(field, prefix)}"
          time_val = instance_variable_get :"@#{Naming.time_getter(field, prefix)}"
          self.send "#{field}=", DateTime.parse("#{date_val} #{time_val}")
        end
      end
    end
  end
end
