require 'csv'

class Upload < ApplicationRecord
  mount_base64_uploader :csv, CsvUploader
  serialize :errs, Array

  def parse
    CSV.foreach(File.join(Rails.root, 'public', self.csv.url), headers: true) do |row|
      u = User.new(first: row['first'], last: row['last'], email: row['email'], phone: row['phone'])
      if !u.save
        self.errs << {line: row, errors: u.errors}
      end
    end
    self.ready = true
    self.save
  end
end
