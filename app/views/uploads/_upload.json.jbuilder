json.extract! upload, :id, :csv, :ready, :errors, :created_at, :updated_at
json.url upload_url(upload, format: :json)
