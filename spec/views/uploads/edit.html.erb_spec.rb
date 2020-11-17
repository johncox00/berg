require 'rails_helper'

RSpec.describe "uploads/edit", type: :view do
  before(:each) do
    @upload = assign(:upload, Upload.create!(
      csv: "MyString",
      ready: false,
      errors: "MyText"
    ))
  end

  it "renders the edit upload form" do
    render

    assert_select "form[action=?][method=?]", upload_path(@upload), "post" do

      assert_select "input[name=?]", "upload[csv]"

      assert_select "input[name=?]", "upload[ready]"

      assert_select "textarea[name=?]", "upload[errors]"
    end
  end
end
