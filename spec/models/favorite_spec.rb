require 'rails_helper'

RSpec.describe Favorite, type: :model do
  it "userとmistakeがあれば有効" do
    favorite = build(:favorite)
    expect(favorite).to be_valid
  end
end
