# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Project, type: :model do

  before do
    @user = User.create(
      first_name: 'taro',
      last_name: 'tanaka',
      email: 'test@test.com',
      password: 'password'
    )
  end

  # 名前、オーナー、タスクがあるなら有効な状態であること
  it 'is valid with a name and owner' do
    project = @user.projects.build(name: 'project name')
    expect(project).to be_valid
  end

  # 名前がないなら無効な状態であること
  it 'is invalid without a name' do
    project = @user.projects.build(name: nil)
    expect(project).to_not be_valid
  end

  # ユーザー単位では重複したプロジェクト名を許可しないこと
  it 'does not allow duplicate project names per user' do
    @user.projects.create(name: 'project name')
    project = @user.projects.build(name: 'project name')
    project.valid?
    expect(project).to_not be_valid
    expect(project.errors[:name]).to include('has already been taken')
  end

  # 2人のユーザーが同じプロジェクト名を使用することは許可すること
  it 'allows two users to share a project name' do
    user2 = User.create(
      first_name: 'jiro',
      last_name: 'sato',
      email: 'test2@test.com',
      password: 'password'
    )
    @user.projects.create(name: 'project name')
    project = user2.projects.build(name: 'project name')
    expect(project).to be_valid
  end
end
