require "rails_helper"

RSpec.describe ActivityType, type: :model do
  subject { FactoryGirl.create(:activity_type, name: "activity") }
  let(:event) { subject.event }

  it { is_expected.to validate_presence_of(:name) }

  it "uses its (plural) slug for URL generation" do
    expect(subject.to_param).to eq("activities")
  end

  context "with siblings" do
    let(:event) { FactoryGirl.create(:event) }

    before do
      3.times { FactoryGirl.create(:activity_type, event: event) }
    end

    it "auto-increments positions" do
      expect(event.activity_types.map(&:position).sort).to eq([0, 1, 2])
    end

    context "when destroyed" do
      before do
        event.activity_types.first.destroy
        event.reload
      end

      it "updates the other activity types' positions" do
        expect(event.activity_types.map(&:position).sort).to eq([0, 1])
      end
    end
  end
end
