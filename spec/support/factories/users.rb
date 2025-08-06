FactoryBot.define do
  factory :user do
    transient do
      pw { Faker::Internet.password(min_length: 12) }
    end

    email_address { Faker::Internet.unique.email }
    password { pw }
    password_confirmation { pw }
  end
end
