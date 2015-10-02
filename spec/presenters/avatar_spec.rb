require "rails_helper"

describe Avatar do
  subject { avatar.to_html }
  let(:avatar) { Avatar.new(user, options) }
  let(:user) { FactoryGirl.create(:user) }
  let(:options) { {} }

  it { is_expected.to include(user.name) }
  it { is_expected.to include("/users/#{user.id}") }

  context "when the user has an image set" do
    let(:kitten) { "http://lorempixel.com/50/50/cats/4/" }

    before do
      expect(user).to receive(:avatar).and_return(kitten)
    end

    it { is_expected.to include(kitten) }
  end

  context "when the user has no image set" do
    before do
      expect(user).to receive(:avatar).and_return(nil)
    end

    it { is_expected.to include("gravatar.com") }
  end

  context "when :name is false" do
    let(:options) { { name: false } }

    it { is_expected.not_to include(user.name) }
  end

  context "when :link is 'http://www.example.com'" do
    let(:options) { { link: "http://www.example.com" } }

    it { is_expected.to include("http://www.example.com") }
  end

  context "when :link is false" do
    let(:options) { { link: false } }

    it { is_expected.not_to include("href") }
  end
end
