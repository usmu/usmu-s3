require 'usmu/deployment/remote_file_interface'
require 'aws-sdk'

module Usmu
  class S3
    class RemoteFiles
      include Usmu::Deployment::RemoteFileInterface

      # @param [Usmu::S3::Configuration] configuration
      #   An S3 configuration to provide connection details to the remote S3 bucket.
      def initialize(configuration)
        @s3 = Aws::S3::Resource.new(credentials: configuration.credentials, region: configuration.region)
        @bucket = @s3.bucket(configuration.bucket)
      end

      # @see Usmu::Deployment::RemoteFileInterface#files_list
      def files_list
        objects.map {|o| o.key }
      end

      # @see Usmu::Deployment::RemoteFileInterface#stat
      def stat(filename)
        obj = objects.select {|o| o.key.eql? filename }.first
        return nil if obj.nil?

        etag = unless obj.etag.index('-')
                 obj.etag.gsub(/^["]|["]$/, '')
               end

        {
            md5: etag,
            mtime: obj.last_modified,
        }
      end

      private

      attr_reader :s3
      attr_reader :bucket

      def objects
        @objects ||= @bucket.objects.to_a
      end
    end
  end
end
