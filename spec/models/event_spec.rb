require "rails_helper"

RSpec.describe Event, type: :model do
  subject { event }
  let(:event) { create(:event, name: "My fancy party") }

  it { is_expected.to validate_presence_of(:name) }
  it { is_expected.to validate_uniqueness_of(:slug).case_insensitive }

  context "with invalid dates" do
    let(:event) do
      build(:event, starts_on: Time.zone.today, ends_on: 1.week.ago)
    end

    it { is_expected.not_to be_valid }
  end

  describe "#slug" do
    subject { event.slug }

    it { is_expected.not_to be_blank }
    it { is_expected.to eq("my-fancy-party") }
  end

  describe "#starts_at" do
    subject { event.starts_at }
    let(:event) do
      create(:event, time_zone: time_zone, starts_on: date, ends_on: date + 1)
    end
    let(:date) { Date.civil(2016, 1, 1) }

    context "for an event in San Francisco" do
      let(:time_zone) { "Pacific Time (US & Canada)" }

      it { is_expected.to eq(Time.utc(2016, 1, 1, 8)) }
    end

    context "for an event in Wellington" do
      let(:time_zone) { "Wellington" }

      it { is_expected.to eq(Time.utc(2015, 12, 31, 11)) }
    end
  end

  describe "#to_param" do
    subject { event.to_param }

    it { is_expected.to eq("my-fancy-party") }
  end

  describe ".administered_by" do
    subject { Event.administered_by(user) }
    let(:user) { create(:user) }

    context "when the user is not an administrator" do
      it { is_expected.not_to include(event) }
    end

    context "when the user is an administrator" do
      before { Administrator.create(user: user, event: event) }

      it { is_expected.to include(event) }
    end
  end
end
