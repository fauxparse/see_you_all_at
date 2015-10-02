require 'rails_helper'

RSpec.describe Identity, type: :model do
  it { is_expected.to validate_presence_of(:provider) }
  it { is_expected.to validate_presence_of(:uid) }
end
