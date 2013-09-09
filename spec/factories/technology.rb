# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
	factory :technology do
		name "MyString"
		description "MyString"
		price 300
		max_lvl 17
		bonus 0.2
		subhouse_bonus 0.2
		house_bonus 0.2
		bonus_type "L"
		image_url "image/vyskum/i_inf.png"
		image_lvl "1*7*15"
		discovered 1
	end
end
