$stdout.sync = true

def ensure_log_goes_to_stdout
  old_logger = Webpacker.logger
  Webpacker.logger = ActiveSupport::Logger.new(STDOUT)
  yield
ensure
  Webpacker.logger = old_logger
end

namespace :webpacker do
  desc "Compile javascript packs using webpack for production with digests"
  task compile: ["webpacker:verify_install", :environment] do
    Webpacker.logger.info "In webpacker:compile task"
    ensure_log_goes_to_stdout do
      if Webpacker.compile
        Webpacker.logger.info "Webpacker compile succeeded"
        # Successful compilation!
      else
        Webpacker.logger.info "Webpacker compile failed"
        # Failed compilation
        exit!
      end
    end
  end
end

# Compile packs after we've compiled all other assets during precompilation
if Rake::Task.task_defined?("assets:precompile")
  Webpacker.logger.info "assets:precompile defined"
  Rake::Task["assets:precompile"].enhance do
    Webpacker.logger.info "checking yarn:install"
    unless Rake::Task.task_defined?("yarn:install")
      # For Rails < 5.1
      Webpacker.logger.info "invoking yarn:install"
      Rake::Task["webpacker:yarn_install"].invoke
    end
    Webpacker.logger.info "about to invoke webpacker:compile"
    #THIS IS NOT BEING INVOKED
    Rake::Task["webpacker:compile"].execute
  end
else
  Webpacker.logger.info "assets:precompile not defined"
end
