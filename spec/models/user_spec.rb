require "rails_helper"

RSpec.describe User, type: :model do
  subject { user }
  let(:user) { FactoryGirl.create(:user) }

  it { is_expected.to validate_presence_of(:name) }

  describe "#requires_email_address?" do
    subject { user.requires_email_address? }

    context "when email address has been entered" do
      it { is_expected.to be(false) }
    end

    context "when email address is missing" do
      before { user.email = user.confirmation_sent_at = nil }

      it { is_expected.to be(true) }
    end
  end
end
