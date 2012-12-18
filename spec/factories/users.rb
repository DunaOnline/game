# == Schema Information
#
# Table name: users
#
#  id            :integer          not null, primary key
#  username      :string(255)      not null
#  nick          :string(255)      not null
#  email         :string(255)
#  password_hash :string(255)
#  password_salt :string(255)
#  house_id      :integer          not null
#  subhouse_id   :integer
#  solar         :decimal(12, 4)   default(0.0)
#  melange       :decimal(12, 4)   default(0.0)
#  exp           :decimal(12, 4)   default(0.0)
#  leader        :boolean          default(FALSE)
#  mentat        :boolean          default(FALSE)
#  army_mentat   :boolean          default(FALSE)
#  diplomat      :boolean          default(FALSE)
#  general       :boolean          default(FALSE)
#  vicegeneral   :boolean          default(FALSE)
#  landsraad     :boolean          default(FALSE)
#  arrakis       :boolean          default(FALSE)
#  emperor       :boolean          default(FALSE)
#  regent        :boolean          default(FALSE)
#  court         :boolean          default(FALSE)
#  vezir         :boolean          default(FALSE)
#  admin         :boolean          default(FALSE)
#  created_at    :datetime
#  updated_at    :datetime
#  influence     :decimal(, )
#  web           :string(255)      default(" ")
#  icq           :string(255)      default(" ")
#  gtalk         :string(255)      default(" ")
#  skype         :string(255)      default(" ")
#  facebook      :string(255)      default(" ")
#  presentation  :text             default(" ")
#  active        :boolean          default(TRUE)
#

# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :user do
    sequence(:username) {|n| "user#{n}"}
    nick {"#{username}nick"}
    email {"#{username}@test.com"}
    password "testtest"
    password_confirmation "testtest"
    house
  end
end
