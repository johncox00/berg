FactoryBot.define do
  factory :upload do
    csv { "some data" }
    ready { false }
    errs { [] }
  end
end
