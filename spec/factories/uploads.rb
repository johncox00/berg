FactoryBot.define do
  factory :upload do
    csv { "MyString" }
    ready { false }
    errors { "MyText" }
  end
end
