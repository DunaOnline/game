# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
	factory :conversation do
		sender 2
		message_id 1
		receiver 5
		deleted_by "S"
		opened false

	end
end
