# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Note, type: :model do
  # 検索文字列に一致するメモを返すこと
  it 'returns notes that match the search term' do
    user = User.create(
      first_name: 'taro',
      last_name: 'tanaka',
      email: 'test@test.com',
      password: 'password'
    )
    project = user.projects.create(name: 'project name')
    note1 = project.notes.create(message: 'This is the first note', user:)
    note2 = project.notes.create(message: 'This is the second note', user:)
    note3 = project.notes.create(message: 'First of all', user:)
    expect(Note.search('first')).to include(note1, note3)
    expect(Note.search('first')).to_not include(note2)
  end

  # 検索文字列に一致するメモが存在しないなら空の配列を返すこと
  it 'returns empty collection when no results are found' do
    user = User.create(
      first_name: 'taro',
      last_name: 'tanaka',
      email: 'test@test.com',
      password: 'password'
    )
    project = user.projects.create(name: 'project name')
    project.notes.create(message: 'This is the first note', user:)
    project.notes.create(message: 'This is the second note', user:)
    project.notes.create(message: 'First of all', user:)
    expect(Note.search('third')).to be_empty
  end
end
