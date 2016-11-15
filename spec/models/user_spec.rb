require 'rails_helper'

RSpec.describe User do
  it { is_expected.to validate_uniqueness_of(:email) }
  it { is_expected.to validate_presence_of(:email) }
  it "is expected to validate the length of name" do
    user = User.new(name: "", email: "hamlet@hamlet.com", password: "password")
    expect(user).not_to be_valid
    long_string = "a" * 26
    user2 = User.new(name: long_string, email: "hamlot@hamlot.com", password: "password")
    expect(user2).not_to be_valid
    user3 = User.new(name: "Zachery Lund", email: "whatev@er.com", password: "password")
    expect(user3).to be_valid
  end
end
