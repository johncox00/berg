require 'csv'
require 'open-uri'

class Upload < ApplicationRecord
  mount_base64_uploader :csv, CsvUploader
  serialize :errs, Array

  after_save :maybe_async_parse

  attr_accessor :do_not_parse

  def maybe_async_parse
    UploadJob.perform_later(self.id) unless self.do_not_parse
  end

  def parse
    self.do_not_parse = true
    CSV.foreach(File.join(Rails.root, 'public', self.csv.url), headers: true) do |row|
      process_row(row)
    end
    self.ready = true
    self.save
  end

  def process_row(row)
    headers = normalized_headers(row)
    u = User.new(first: row[headers[:first]], last: row[headers[:last]], email: row[headers[:email]], phone: row[headers[:phone]])
    if !u.save
      self.errs << {line: row, errors: u.errors}
    end
  end

  def normalized_headers(row)
    @normalized_headers ||= {
      first: normalize_key('first', row),
      last: normalize_key('last', row),
      phone: normalize_key('phone', row),
      email: normalize_key('email', row)
    }
  end

  def normalize_key(key, row)
    keys = row.to_h.keys
    keys.select{|k| /#{key}/i.match(k)}[0]
  end
end
