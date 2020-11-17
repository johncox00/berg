FactoryBot.define do
  factory :user do
    first { "John" }
    last  { "Doe" }
    email { "jack@beanstalk.com" }
    phone { "(203)378-2309" }
  end
end
