class Upload < ApplicationRecord
  mount_base64_uploader :csv, CsvUploader
  serialize :errors, Array
end
