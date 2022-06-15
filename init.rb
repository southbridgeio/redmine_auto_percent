require 'redmine'

register_after_redmine_initialize_proc =
  if Redmine::VERSION::MAJOR >= 5
    Rails.application.config.public_method(:after_initialize)
  else
    reloader = defined?(ActiveSupport::Reloader) ? ActiveSupport::Reloader : ActionDispatch::Reloader
    reloader.public_method(:to_prepare)
  end
register_after_redmine_initialize_proc.call do
  require_dependency 'issue'
  # Guards against including the module multiple time (like in tests)
  # and registering multiple callbacks
  unless Issue.included_modules.include? RedmineAutoPercent::IssuePatch
    Issue.send(:include, RedmineAutoPercent::IssuePatch)
  end
end

Redmine::Plugin.register :redmine_auto_percent do
  name 'Redmine Auto Done 100%'
  author 'Wade Womersley'
  description 'Automatically sets 100% done on Resolved or Closed'
  version '0.0.2'
  url ''
  author_url 'http://www.xcitestudios.com/'
end
