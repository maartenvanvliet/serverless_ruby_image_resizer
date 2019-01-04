require 'uploaded_file'

# Shape of the incoming event
# {
#     "Records" => [{
#         "eventVersion" => "2.1",
#         "eventSource" => "aws:s3",
#         "awsRegion" => "us-east-1",
#         "eventTime" => "2019-01-03T18:16:48.929Z",
#         "eventName" => "ObjectCreated:Put",
#         "userIdentity" => {
#             "principalId" => "A27JUW5C809VAC"
#         },
#         "requestParameters" => {
#             "sourceIPAddress" => "125.119.99.217"
#         },
#         "responseElements" => {
#             "x-amz-request-id" => "A29996858BF4F065",
#             "x-amz-id-2" => "4ew1iSaNZzBxaIYEld8ApxW6BwY8y4LiRSZrX02HizchpNnz1E70BeE35t3/0WfWhDgCuVVMaSw="
#         },
#         "s3" => {
#             "s3SchemaVersion" => "1.0",
#             "configurationId" => "26883ef7-2848-4cf4-9afc-e5192f7416bd",
#             "bucket" => {
#                 "name" => "name-of-bucket",
#                 "ownerIdentity" => {
#                     "principalId" => "A27JUW5C709VAC"
#                 },
#                 "arn" => "arn:aws:s3:::name-of-bucket"
#             },
#             "object" => {
#                 "key" => "test.jpg",
#                 "size" => 70899,
#                 "eTag" => "086f1c5ed2422109c3af16e68f415b47",
#                 "sequencer" => "005D2E5190D7C629C3"
#             }
#         }
#     }]
# }
class ImageHandler

  def self.process(event:, context:)
    event = event["Records"].first
    bucket_name = event["s3"]["bucket"]["name"]
    object_name = event["s3"]["object"]["key"]

    file = UploadedFile.from_s3(bucket_name, object_name)
    file.resize "100x100"
    file.upload_file("resized-your-images", "resized_" + event["s3"]["object"]["key"] )
  end
end