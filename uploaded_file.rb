require "aws-sdk-s3"
require "mini_magick"

class UploadedFile
    def self.from_s3(bucket_name, object_name)
        s3 = Aws::S3::Resource.new()
        object = s3.bucket(bucket_name).object(object_name)

        tmp_file_name = "/tmp/#{object_name}"
        object.get(response_target: tmp_file_name)
        
        UploadedFile.new(tmp_file_name)
    end

    def initialize(tmp_file)
        @tmp_file = tmp_file
    end

    def resize(params)
        image = MiniMagick::Image.open(@tmp_file)
        image.resize params
        @resized_tmp_file = "/tmp/resized.jpg"
        image.write @resized_tmp_file
    end

    def upload_file(target_bucket, target_object)
        s3 = Aws::S3::Resource.new()
        object = s3.bucket(target_bucket).object(target_object).upload_file(@resized_tmp_file)
    end
end