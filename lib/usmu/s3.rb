%w{
  logging
  usmu/s3/s3_configuration
  usmu/s3/version
}.each {|f| require f }

# Module from Usmu Core
module Usmu
  # Usmu::S3 is the main plugin class for this plugin. It contains entry hooks as required to implement the S3
  # deployment interface.
  class S3
    def initialize
      @log = Logging.logger[self]
      @log.debug("Initializing usmu-s3 v#{Usmu::S3::VERSION}")
    end

    # @see Usmu::Plugin::CoreHooks#commands
    def commands(ui, c)
      @log.debug('Adding commands from usmu-s3.')
      @ui = ui

      c.command(:'s3 deploy') do |command|
        command.syntax = 'usmu s3 deploy'
        command.description = 'Deploys your website to S3'
        command.action &method(:command_deploy)
      end
    end

    def command_deploy(args, options)
      @configuration = S3Configuration.new(@ui.configuration['plugin', 's3', default: {}])
      p @configuration
      @log.info('Deploying to AWS S3 with rainbows and fairy dust (coming soon).')
    end
  end
end
