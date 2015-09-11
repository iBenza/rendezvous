# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do

  factory :post do
    association :author, factory: :author
    title 'sample title'
    body 'sample body'
    specified_date Date.new(2014, 4, 1)

    after(:create) do |post|
      create(:post_tag, post: post, tag: create(:tag_ruby))
    end
  end

  factory :post_tag do
  end
end
