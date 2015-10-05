require "rails_helper"

RSpec.describe Package, type: :model do
  it { is_expected.to validate_presence_of(:name) }
  it { is_expected.to validate_uniqueness_of(:name).scoped_to(:event_id) }

  it { is_expected.to validate_presence_of(:slug) }
  it { is_expected.to validate_uniqueness_of(:slug).scoped_to(:event_id) }
end
