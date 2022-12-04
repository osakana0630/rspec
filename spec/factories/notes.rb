FactoryBot.define do
  factory :note do
    message { 'This is important' }
    association :project
    user { project.owner }
  end
end
