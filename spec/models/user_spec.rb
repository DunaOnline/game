require 'spec_helper'

describe User do
  it "counts political influence" do
    user  = create(:user)
    pp = user.politicke_postaveni

    expect(pp).to eq(1.00)
  end
  it "counts political influence - emperor" do
    user  = create(:user, :emperor => true)
    pp = user.politicke_postaveni

    expect(pp).to eq(1.05)
  end
  it "counts political influence - arrakis" do
    user  = create(:user, :arrakis => true)
    pp = user.politicke_postaveni

    expect(pp).to eq(1.05)
  end
  it "counts political influence - regent" do
    user  = create(:user, :regent => true)
    pp = user.politicke_postaveni

    expect(pp).to eq(1.02)
  end
  it "counts political influence - leader" do
    user  = create(:user, :leader => true)
    pp = user.politicke_postaveni

    expect(pp).to eq(1.02)
  end
  it "counts political influence - landsraad" do
    user  = create(:user, :landsraad => true)
    pp = user.politicke_postaveni

    expect(pp).to eq(1.02)
  end
  it "counts political influence - court" do
    user  = create(:user, :court => true)
    pp = user.politicke_postaveni

    expect(pp).to eq(1.02)
  end
  it "counts political influence - vezit" do
    user  = create(:user, :vezir => true)
    pp = user.politicke_postaveni

    expect(pp).to eq(1.02)
  end
  it "counts political influence - mentat" do
    user  = create(:user, :mentat => true)
    pp = user.politicke_postaveni

    expect(pp).to eq(1.01)
  end
  it "counts political influence - army_mentat" do
    user  = create(:user, :army_mentat => true)
    pp = user.politicke_postaveni

    expect(pp).to eq(1.01)
  end
  it "counts political influence - diplomat" do
    user  = create(:user, :diplomat => true)
    pp = user.politicke_postaveni

    expect(pp).to eq(1.01)
  end
  it "counts political influence - general" do
    user  = create(:user, :general => true)
    pp = user.politicke_postaveni

    expect(pp).to eq(1.01)
  end
  it "counts political influence - vicegeneral" do
    user  = create(:user, :vicegeneral => true)
    pp = user.politicke_postaveni

    expect(pp).to eq(1.01)
  end
  it "counts political influence - emperor + arrakis" do
    user  = create(:user, :emperor => true, :arrakis => true)
    pp = user.politicke_postaveni

    expect(pp).to eq(1.05)
  end
  it "counts political influence - emperor + leader" do
    user  = create(:user, :emperor => true, :leader => true)
    pp = user.politicke_postaveni

    expect(pp).to eq(1.05)
  end
  it "counts political influence - leader + mentat" do
    user  = create(:user, :leader => true, :mentat => true)
    pp = user.politicke_postaveni

    expect(pp).to eq(1.02)
  end
  it "counts political influence - landsraad + general" do
    user  = create(:user, :landsraad => true, :general => true)
    pp = user.politicke_postaveni

    expect(pp).to eq(1.02)
  end
  it "counts political influence - all" do
    user  = create(:user, :emperor => true, :arrakis => true, :leader => true, :landsraad => true,
                   :court => true, :vezir => true, :mentat => true, :army_mentat => true, :diplomat => true,
                   :general => true)
    pp = user.politicke_postaveni

    expect(pp).to eq(1.05)
  end

end

