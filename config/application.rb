require File.expand_path('../boot', __FILE__)

require 'rails/all'
require 'thread'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Rpiytjb
  class Application < Rails::Application
    def start_mutex
      @start_mutex ||= Mutex.new
    end

    def playback_mutex
      @playback_mutex ||= Mutex.new
    end

    config.active_record.raise_in_transactional_callbacks = true
    config.after_initialize do
      Playback.update_all(is_playing: false) if Playback.table_exists?
    end
  end
end
