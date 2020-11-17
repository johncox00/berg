require 'rails_helper'

RSpec.describe UploadsController, type: :controller do
  render_views
  it 'allows the csv file to be uploaded' do

    csv_data = "data:text/csv;base64,Zmlyc3QsbGFzdCxlbWFpbCxwaG9uZQpKb2UsQmxvdyxqb2VAYmxvdy5jb20sODE3LTI4Mi01NjYwCkphbmUsRG9lLGphbmVAZG9lLmNvbSw0NzktNDI2LTM5NTkK"

    post :create, params: {upload: {csv: csv_data}}, format: :json
    jsonResponse = JSON.parse(response.body)

    expect(jsonResponse["csv"]["url"]).to match(/csv.csv/)
  end

  it 'allows a user to check on the progress of parsing the file' do
    csv = create(:upload, ready: true)
    get :show, params: {id: csv.id}, format: :json
    jsonResponse = JSON.parse(response.body)
    expect(jsonResponse['ready']).to eq(true)
  end

  it 'allows a user to understand errors' do
    csv = create(:upload, errs: ['one', 'two'])
    get :show, params: {id: csv.id}, format: :json
    jsonResponse = JSON.parse(response.body)
    expect(jsonResponse['errs']).to eq(['one', 'two'])
  end
end
