
module Usmu
  class S3
    class S3Configuration
      def initialize(hash)
        @config = hash
      end

      def access_key
        substitute_env @config['access key']
      end

      def secret_key
        substitute_env @config['secret key']
      end

      def bucket
        substitute_env @config['bucket']
      end

      def inspect
        "#<#{self.class.name} access_key=\"#{access_key}\" bucket=\"#{bucket}\">"
      end

      private

      def substitute_env(string)
        string.gsub(/%env{([^}]*)}/) { ENV[$1] }
      end
    end
  end
end
