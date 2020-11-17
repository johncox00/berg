json.extract! upload, :id, :csv, :ready, :errs, :created_at, :updated_at
json.url upload_url(upload, format: :json)
