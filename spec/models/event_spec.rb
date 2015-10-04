require "rails_helper"

RSpec.describe Event, type: :model do
  subject { event }
  let(:event) { FactoryGirl.create(:event, name: "My fancy party") }

  it { is_expected.to validate_presence_of(:name) }
  it { is_expected.to validate_uniqueness_of(:slug).case_insensitive }

  context "#slug" do
    subject { event.slug }

    it { is_expected.not_to be_blank }
    it { is_expected.to eq("my-fancy-party") }
  end

  context "#starts_at" do
    subject { event.starts_at }
    let(:event) { FactoryGirl.create(:event, attrs) }
    let(:attrs) { { time_zone: time_zone, starts_on: date } }
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
end
