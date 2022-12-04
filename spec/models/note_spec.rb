# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Note, type: :model do
  # ファクトリで関連するデータを作成する
  it 'generates associated data from a factory' do
    note = create(:note)
    expect(note.user).to_not be nil
    expect(note.project).to_not be nil
  end

  # ユーザー、プロジェクト、メッセージがあれば有効な状態であること　
  it 'is valid with a user, project and message' do
    expect(build(:note)).to be_valid
  end

  # ユーザーがなければ無効な状態であること　
  it 'is invalid without a user' do
    expect(build(:note, user: nil)).to_not be_valid
  end

  # プロジェクトがなければ無効な状態であること　
  it 'is invalid without a project' do
    # projectからuserを作成しているため、有効なnoteを作成した上でprojectをnilにする
    note = build(:note)
    note.project = nil
    expect(note).to_not be_valid
  end

  # メッセージがなければ無効な状態であること　
  it 'is invalid without a message' do
    expect(build(:note, message: nil)).to_not be_valid
  end

  # searchスコープに関するテスト
  describe '.search' do
    before do
      user = create(:user)
      @note1 = create(:note, user:, message: 'This is the first note')
      @note2 = create(:note, user:, message: 'This is the second note')
      @note3 = create(:note, user:, message: 'First of all')
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
