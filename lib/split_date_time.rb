require 'split_date_time/splitter'

module SplitDateTime
  if defined? Rails::Railtie
    require 'rails'
    class Railtie < Rails::Railtie
      initializer 'split_date_time.insert_into_active_record' do
        ActiveSupport.on_load :active_record do
          SplitDateTime::Railtie.insert
        end
      end
    end
  end

  class Railtie
    def self.insert
      if defined?(ActiveRecord)
        ActiveRecord::Base.send(:include, SplitDateTime::Splitter)
      end
    end
  end
end
