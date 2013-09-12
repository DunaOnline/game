# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
	factory :message do
		body "MyString"
		subject "MyString"
		recipients "minohimself, opica"
		user_id 1
		druh "M"

	end
end
