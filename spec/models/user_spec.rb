# frozen_string_literal: true

require 'rails_helper'

RSpec.describe User, type: :model do
  # 姓、名、メール、パスワードがあれば有効な状態であること
  it 'is valid with a first_name, last_name, email, and password' do
    user = User.new(
      first_name: 'taro',
      last_name: 'tanaka',
      email: 'test@test.com',
      password: 'password'
    )
    expect(user).to be_valid
  end

  # 名がないなら無効な状態であること
  it 'is invalid without a first_name' do
    user = User.new(
      first_name: nil,
      last_name: 'tanaka',
      email: 'test@test.com',
      password: 'password'
    )
    user.valid?
    expect(user).to_not be_valid
    expect(user.errors[:first_name]).to include("can't be blank")
  end

  # 姓がないなら無効な状態であること
  it 'is invalid without a last_name' do
    user = User.new(
      first_name: 'taro',
      last_name: nil,
      email: 'test@test.com',
      password: 'password'
    )
    user.valid?
    expect(user).to_not be_valid
    expect(user.errors[:last_name]).to include("can't be blank")
  end

  # 重複したメールアドレスなら無効な状態であること
  it 'is invalid with a duplicate email' do
    User.create(
      first_name: 'taro',
      last_name: 'tanaka',
      email: 'test@test.com',
      password: 'password'
    )
    user = User.new(
      first_name: 'jiro',
      last_name: 'hayashi',
      email: 'test@test.com',
      password: 'password'
    )
    user.valid?
    expect(user).to_not be_valid
    expect(user.errors[:email]).to include('has already been taken')
  end

  # ユーザーのフルネームを返却すること
  it "returns user's full name as a string" do
    user = User.create(
      first_name: 'taro',
      last_name: 'tanaka',
      email: 'test@test.com',
      password: 'password'
    )
    expect(user.name).to eql 'taro tanaka'
  end
end
