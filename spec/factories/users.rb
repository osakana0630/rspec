FactoryBot.define do
  factory :user do
    first_name { 'Taro' }
    last_name { 'Tanaka' }
    email { 'test@test.com' }
    password { 'password' }
  end
end
