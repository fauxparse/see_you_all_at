require "rails_helper"

RSpec.describe Package, type: :model do
  subject { FactoryGirl.create(:package, event: event) }
  let(:event) { FactoryGirl.create(:event) }

  it { is_expected.to validate_presence_of(:name) }
  it { is_expected.to validate_uniqueness_of(:name).scoped_to(:event_id) }

  it "uses its slug for URL generation" do
    expect(subject.to_param).to match(/^package-\d+$/)
  end

  context "with siblings" do
    subject { event.packages.first }

    before do
      3.times { FactoryGirl.create(:package, event: event) }
    end

    it "auto-increments positions" do
      expect(event.packages.map(&:position).sort).to eq([0, 1, 2])
    end

    context "when destroyed" do
      before do
        subject.destroy
        event.reload
      end

      it "updates the other packages' positions" do
        expect(event.packages.map(&:position).sort).to eq([0, 1])
      end
    end
  end
end
