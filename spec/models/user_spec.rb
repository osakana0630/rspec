# frozen_string_literal: true

require 'rails_helper'

RSpec.describe User, type: :model do

  # 有効なファクトリを持つこと
  it 'has a valid factory' do
    expect(build(:user)).to be_valid
  end

  # 姓、名、メール、パスワードがあれば有効な状態であること
  it 'is valid with a first_name, last_name, email, and password' do
    expect(build(:user)).to be_valid
  end

  # 名がないなら無効な状態であること
  it 'is invalid without a first_name' do
    user = build(:user, first_name: nil)
    user.valid?
    expect(user).to_not be_valid
    expect(user.errors[:first_name]).to include("can't be blank")
  end

  # 姓がないなら無効な状態であること
  it 'is invalid without a last_name' do
    user = build(:user, last_name: nil,)
    user.valid?
    expect(user).to_not be_valid
    expect(user.errors[:last_name]).to include("can't be blank")
  end

  # 重複したメールアドレスなら無効な状態であること
  it 'is invalid with a duplicate email' do
    create(:user, email: 'test@test.com')
    user = build(:user, email: 'test@test.com')
    user.valid?
    expect(user).to_not be_valid
    expect(user.errors[:email]).to include('has already been taken')
  end

  # ユーザーのフルネームを返却すること
  describe '#name' do
    it "returns user's full name as a string" do
      expect(create(:user).name).to eql 'Taro Tanaka'
    end
  end
end
