require "rails_helper"

RSpec.describe Package, type: :model do
  subject { FactoryGirl.create(:package) }

  it { is_expected.to validate_presence_of(:name) }
  it { is_expected.to validate_uniqueness_of(:name).scoped_to(:event_id) }
end
