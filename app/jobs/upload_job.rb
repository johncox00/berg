class UploadJob < ApplicationJob
  queue_as :default

  def perform(id)
    upload = Upload.find(id)
    upload.parse
  end
end
