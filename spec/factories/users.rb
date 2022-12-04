# frozen_string_literal: true

FactoryBot.define do
  factory :user do
    first_name { 'Taro' }
    last_name { 'Tanaka' }
    sequence(:email) { |n| "test#{n}@test.com" }
    password { 'password' }
  end
end
