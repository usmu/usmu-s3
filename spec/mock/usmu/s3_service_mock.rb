
module Usmu
  class S3ServiceMock
    attr_accessor :objects

    class ArrayWrapper
      def initialize(objects)
        @objects = objects
      end

      def to_a
        @objects
      end
    end

    def initialize(objects)
      @objects = ArrayWrapper.new(objects)
    end

    def bucket(name)
      @bucket = name
      self
    end

    def get_bucket
      @bucket
    end

    def put_object(hash)
    end

    def delete_objects(request)
    end
  end
end
