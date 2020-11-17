require 'rails_helper'

RSpec.describe "uploads/show", type: :view do
  before(:each) do
    @upload = assign(:upload, Upload.create!(
      csv: "Csv",
      ready: false,
      errors: "MyText"
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/Csv/)
    expect(rendered).to match(/false/)
    expect(rendered).to match(/MyText/)
  end
end
