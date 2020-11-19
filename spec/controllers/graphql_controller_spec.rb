require 'rails_helper'

RSpec.describe GraphqlController, type: :controller do
  it 'retrieves users' do
    3.times{create(:user)}
    query = '{ users(page: 2, per: 2) { currentPage totalPages totalCount results { id first last email phone } } }'
    post :execute, params: {query: query}, format: :json
    jsonResponse = JSON.parse(response.body)

    expect(jsonResponse["data"]["users"]["totalPages"]).to eq(2)
    expect(jsonResponse["data"]["users"]["results"].length).to eq(1)
  end
end
