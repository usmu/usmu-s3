require 'aws-sdk'

module Usmu
  class S3
    class S3Configuration
      def initialize(hash)
        @config = hash
      end

      def region
        substitute_env(@config['region'] || '%env{AWS_REGION}')
      end

      def access_key
        substitute_env(@config['access key'] || '%env{AWS_ACCESS_KEY_ID}')
      end

      def secret_key
        substitute_env(@config['secret key'] || '%env{AWS_SECRET_ACCESS_KEY}')
      end

      def bucket
        substitute_env @config['bucket'] || ''
      end

      def reduced_redundancy
        @config['reduced redundancy'] || false
      end

      def redirects
        @config['redirects'] || {}
      end

      def inspect
        "\#<#{self.class} region=\"#{region}\" access_key=\"#{access_key}\" bucket=\"#{bucket}\">"
      end

      def credentials
        @credentials ||= Aws::Credentials.new(access_key, secret_key)
      end

      private

      def substitute_env(string)
        string.gsub(%r[%env\{([^}]*)\}]) { ENV[$1] }
      end
    end
  end
end
