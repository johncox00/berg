require 'rails_helper'

RSpec.describe UploadWorker do
  it 'calls parse on the upload' do
    u = create(:upload)
    expect_any_instance_of(Upload).to receive(:parse)
    UploadWorker.new.perform(u.id)
  end
end
