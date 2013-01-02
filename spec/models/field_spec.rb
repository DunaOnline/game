# == Schema Information
#
# Table name: fields
#
#  id         :integer          not null, primary key
#  user_id    :integer
#  planet_id  :integer          not null
#  name       :string(255)      not null
#  pos_x      :decimal(, )      default(0.0)
#  pos_y      :decimal(, )      default(0.0)
#  created_at :datetime
#  updated_at :datetime
#

# To change this template, choose Tools | Templates
# and open the template in the editor.

require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Field do

  it "check availabilty of popuation" do
    user = create(:user)
    field = create(:field, user: user)
    puts field.to_yaml
    puts Resource.all.to_yaml

#    check = field.check_availability('Population', 50000.0)
#    expect(check).to eq(true)

#    check = field.check_availability('Population', 150000.0)
#    expect(check).to eq(false)
  end
end

