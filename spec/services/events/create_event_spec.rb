require "rails_helper"

describe CreateEvent do
  subject { service.call }
  let(:service) { CreateEvent.new(user, params) }
  let(:user) { FactoryGirl.create(:user) }
  let(:params) { FactoryGirl.attributes_for(:event) }

  it { is_expected.to be true }

  it "does not raise an error" do
    expect { subject }.not_to raise_error
  end

  it "creates an event" do
    expect { subject }.to change { Event.count }.by(1)
  end

  it "creates an administrator" do
    expect { subject }.to change { Administrator.count }.by(1)
    expect(Administrator.last.user).to eq(user)
  end

  it "creates a default package" do
    expect { subject }.to change { Package.count }.by(1)
    expect(Package.last.name).to eq("Basic")
  end

  it "creates a default activity type" do
    expect { subject }.to change { ActivityType.count }.by(1)
    expect(ActivityType.last.name).to eq("activity")
  end

  context "without an event name" do
    let(:params) { FactoryGirl.attributes_for(:event).except(:name) }

    it "raises an error" do
      expect { subject }.to raise_error(ActiveRecord::RecordInvalid)
    end
  end

  context "with no user" do
    let(:user) { nil }

    it "denies access" do
      expect { subject }.to raise_error(Consul::Powerless)
    end
  end
end
