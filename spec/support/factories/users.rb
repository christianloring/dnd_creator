FactoryBot.define do
  factory :user do
    transient do
      pw { "password123" } # Default to a known password for testing
    end

    email_address { Faker::Internet.unique.email }
    password { pw }
    password_confirmation { pw }

    # Trait for random password if needed
    trait :random_password do
      transient do
        pw { Faker::Internet.password(min_length: 12) }
      end
    end
  end
end
