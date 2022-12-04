# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Note, type: :model do
  before do
    @user = User.create!(
      first_name: 'taro',
      last_name: 'tanaka',
      email: 'test@test.com',
      password: 'password'
    )
    @project = @user.projects.create!(name: 'project name')
  end

  # ユーザー、プロジェクト、メッセージがあれば有効な状態であること　
  it 'is valid with a user, project and message' do
    note = @project.notes.build(
      message: 'test message',
      user: @user
    )
    expect(note).to be_valid
  end

  # ユーザーがなければ無効な状態であること　
  it 'is invalid without a user' do
    note = @project.notes.build(
      message: 'test message',
      user: nil
    )
    expect(note).to_not be_valid
  end

  # プロジェクトがなければ無効な状態であること　
  it 'is invalid without a project' do
    note = Note.new(
      message: 'test message',
      user: @user,
      project: nil
    )
    expect(note).to_not be_valid
  end

  # メッセージがなければ無効な状態であること　
  it 'is invalid without a message' do
    note = @project.notes.build(
      message: nil,
      user: @user
    )
    expect(note).to_not be_valid
  end

  # searchスコープに関するテスト
  describe '.search' do
    before do
      @note1 = @project.notes.create(message: 'This is the first note', user: @user)
      @note2 = @project.notes.create(message: 'This is the second note', user: @user)
      @note3 = @project.notes.create(message: 'First of all', user: @user)
    end

    # 一致するメモが見つかる場合
    context 'when a match is found' do
      # 検索文字列に一致するメモを返すこと
      it 'returns notes that match the search term' do
        expect(Note.search('first')).to include(@note1, @note3)
        expect(Note.search('first')).to_not include(@note2)
      end
    end

    # 一致するメモが見つからない場合
    context 'when no match is found' do
      # 検索文字列に一致するメモが存在しないなら空の配列を返すこと
      it 'returns empty collection when no results are found' do
        expect(Note.search('third')).to be_empty
      end
    end
  end
end
