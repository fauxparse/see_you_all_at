require "rails_helper"

RSpec.describe Administrator, type: :model do
  it { is_expected.to validate_presence_of(:event) }
  it { is_expected.to validate_presence_of(:user) }
end
