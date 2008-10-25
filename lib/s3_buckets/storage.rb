module Paperclip
  module Storage
    module S3
      class << self
        alias_method :original_extended, :extended
      end
      
      def self.extended base
        original_extended(base)
        base.class.interpolations[:s3_url] = lambda do |attachment, style|
          "http://#{attachment.bucket_name}.s3.amazonaws.com/#{attachment.path(style).gsub(%r{^/}, "")}"
        end
      end
      
      def s3_bucket
        @s3_bucket ||= s3.bucket(bucket, true, @s3_permissions)
      end

      def bucket_name
        bucket
      end
      
      def bucket
        @bucket.is_a?(Proc) ? @bucket.call(self) : @bucket
      end
    end
  end
end