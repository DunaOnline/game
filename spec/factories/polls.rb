
FactoryGirl.define do
	factory :poll do
		sequence( :user_id ) { |n| "#{n}" }
		law_id 1
		choice 'Ano'

	end
end