require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module VeganChoices
  class Application < Rails::Application
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.
    config.autoload_paths += %w(lib/)
    Rails.application.config.active_record.belongs_to_required_by_default = false
    config.action_view.field_error_proc = Proc.new { |html_tag, instance|
      "<div class=\"field error\">#{html_tag}</div>".html_safe

    }

    config.exception_handler = {
      layouts: {
        500 => nil,
        501 => nil,
        502 => nil,
        503 => nil,
        504 => nil,
        505 => nil,
        507 => nil,
        510 => nil
      }
    }
  end
end
