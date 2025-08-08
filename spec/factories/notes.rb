FactoryBot.define do
  factory :note do
    title { "MyString" }
    body { "MyText" }
    notable { nil }
    user { nil }
  end
end
