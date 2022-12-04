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
    expect(build(:project)).to be_valid
  end

  # 名前がないなら無効な状態であること
  it 'is invalid without a name' do
    project = build(:project, name: nil)
    expect(project).to_not be_valid
  end

  # ユーザー単位では重複したプロジェクト名を許可しないこと
  it 'does not allow duplicate project names per user' do
    user = create(:user)
    create(:project, name: 'fist project', owner: user)
    new_project = build(:project, name: 'fist project', owner: user)

    new_project.valid?
    expect(new_project).to_not be_valid
    expect(new_project.errors[:name]).to include('has already been taken')
  end

  # 2人のユーザーが同じプロジェクト名を使用することは許可すること
  it 'allows two users to share a project name' do
    user1 = create(:user)
    user2 = create(:user)
    create(:project, owner: user1, name: 'project name')
    new_project = build(:project, owner: user2, name: 'project name')
    expect(new_project).to be_valid
  end

  describe '#late?' do
    # 締切日が過ぎていれば遅延していること
    it 'is late when the due date is past today' do
      project = create(:project, :due_yesterday)
      expect(project).to be_late
    end
    # 締切日が今日ならスケジュール通りであること
    it 'is on time when the due date is today' do
      project = create(:project, :due_today)
      expect(project).to_not be_late
    end
    # 締切日が未来ならスケジュール通りであること
    it 'is on time when the due date is in the future' do
      project = create(:project, :due_tomorrow)
      expect(project).to_not be_late
    end
  end
end
