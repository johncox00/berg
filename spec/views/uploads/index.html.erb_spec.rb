require 'rails_helper'

RSpec.describe "uploads/index", type: :view do
  before(:each) do
    assign(:uploads, [
      Upload.create!(
        csv: "Csv",
        ready: false,
        errors: "MyText"
      ),
      Upload.create!(
        csv: "Csv",
        ready: false,
        errors: "MyText"
      )
    ])
  end

  it "renders a list of uploads" do
    render
    assert_select "tr>td", text: "Csv".to_s, count: 2
    assert_select "tr>td", text: false.to_s, count: 2
    assert_select "tr>td", text: "MyText".to_s, count: 2
  end
end
