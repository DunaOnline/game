# == Schema Information
#
# Table name: globals
#
#  id         :integer          not null, primary key
#  setting    :string(255)      not null
#  value      :boolean
#  datum      :date
#  slovo      :string(255)
#  cislo      :decimal(12, 4)
#  created_at :datetime
#  updated_at :datetime
#

require 'spec_helper'

describe Global do

  it "switches and shows setting - value" do
    global = create(:global, setting: 'Test')

    Global.prepni('Test', 1, true)

    global_show = Global.vrat('Test', 1)

    expect(global_show).to eq(true)
  end

  it "switches and shows setting - datum" do
    global = create(:global, setting: 'Test')

    date = '20.12.2012'.to_date

    Global.prepni('Test', 2, date)

    global_show = Global.vrat('Test', 2)

    expect(global_show).to eq(date)
  end

  it "switches and shows setting - slovo" do
    global = create(:global, setting: 'Test')

    word = 'test word'

    Global.prepni('Test', 3, word)

    global_show = Global.vrat('Test', 3)

    expect(global_show).to eq(word)
  end

  it "switches and shows setting - cislo" do
    global = create(:global, setting: 'Test')

    nr = 1111.11

    Global.prepni('Test', 4, nr)

    global_show = Global.vrat('Test', 4)

    expect(global_show).to eq(nr)
  end

end
