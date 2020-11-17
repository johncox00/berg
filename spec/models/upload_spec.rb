require 'rails_helper'

RSpec.describe Upload, type: :model do
  # first,last,email,phone
  # Joe,Blow,joe@blow.com,817-282-5660
  # ,Doe,jane,4426-3959
  let(:import_csv){'data:text/csv;base64,Zmlyc3QsbGFzdCxlbWFpbCxwaG9uZQpKb2UsQmxvdyxqb2VAYmxvdy5jb20sODE3LTI4Mi01NjYwCixEb2UsamFuZSw0MjYtMzk1OQo='}

  it 'parses the csv' do
    upload = create(:upload, csv: import_csv)
    expect(upload.ready).to be_falsey
    expect{
      upload.parse
    }.to change(User, :count).by(1)
    expect(upload.errs.count).to eq(1)
    expect(upload.errs[0][:errors].count).to eq(3)
    expect(upload.ready).to be_truthy
  end

  it 'does not call the asynchronous parsing when not necessary' do
    expect(UploadWorker).to_not receive(:perform_async)
    u = build(:upload)
    u.do_not_parse = true
    u.save
  end

  it 'does call the asyn parsing when needed' do
    expect(UploadWorker).to receive(:perform_async)
    u = build(:upload)
    u.save
  end
end
