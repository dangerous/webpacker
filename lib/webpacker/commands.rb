class Webpacker::Commands
  delegate :config, :compiler, :manifest, to: :@webpacker

  def initialize(webpacker)
    @webpacker = webpacker
  end

  def clobber
    config.public_output_path.rmtree if config.public_output_path.exist?
    config.cache_path.rmtree if config.cache_path.exist?
  end

  def bootstrap
    config.refresh
    manifest.refresh
  end

  def compile
    Webpacker.logger.info "In Webpacker.compile"
    raise "If this doesn't raise we aren't getting to webpacker compile!"
    compiler.compile.tap do |success|
      Webpacker.logger.info "Webpacker compile #{success ? "succeeded" : "failed"}"
      manifest.refresh if success
    end
  end
end
