FactoryBot.define do
  factory :user do
    sequence(:email)  { |n| "test#{n}@test.com" }
    sequence(:username) { |n| "user#{n}" }

    password { 'testtest' }
    password_confirmation { password }
  end
end
