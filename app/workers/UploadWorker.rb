class UploadWorker
  include Sidekiq::Worker

  def perform(id)
    upload = Upload.find(id)
    upload.parse
  end
end
