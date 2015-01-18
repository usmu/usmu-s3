
module Usmu
  class S3
    class Uploader
      # @param [Usmu::Configuration] configuration
      # @param [Usmu::S3::S3Configuration] s3_configuration
      def initialize(configuration, s3_configuration)
        @log = Logging.logger[self]
        @configuration = configuration
        @s3_configuration = s3_configuration
        s3 = Aws::S3::Resource.new(credentials: s3_configuration.credentials, region: s3_configuration.region)
        @bucket = s3.bucket(s3_configuration.bucket)
      end

      def push(diff)
        push_local(diff[:local])
        push_local(diff[:updated])
        delete_remote(diff[:remote])
      end

      private

      attr_reader :log
      attr_reader :configuration
      attr_reader :s3_configuration
      attr_reader :bucket

      def push_local(files)
        storage_class = @s3_configuration.reduced_redundancy ? 'REDUCED_REDUNDANCY' : 'STANDARD'
        for file in files
          @log.success("Uploading #{file}")
          File.open(File.join(@configuration.destination_path, file), 'r') do |io|
            @bucket.put_object({
                                   key: file,
                                   body: io,
                                   storage_class: storage_class
                               })
          end
        end
      end

      def delete_remote(files)
        # We can 'only' delete 1000 items at a time with #delete_objects.
        for i in (0...files.length).step(1000)
          deleting = files.slice(i, 1000)
          for f in deleting
            @log.success("Deleting #{f}")
          end
          @bucket.delete_objects({delete: {objects: deleting.map { |f| {key: f} }}})
        end
      end
    end
  end
end
