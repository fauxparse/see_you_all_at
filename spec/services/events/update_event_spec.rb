require "rails_helper"

describe UpdateEvent do
  subject { service.call }
  let(:service) { UpdateEvent.new(event, params) }
  let(:event) { FactoryGirl.create(:event) }
  let(:params) { { name: new_name } }
  let(:new_name) { "Updated name" }

  it { is_expected.to be true }

  it "does not raise an error" do
    expect { subject }.not_to raise_error
  end

  it "updates the name" do
    service.call
    event.reload
    expect(event.name).to eq(new_name)
  end

  context "without an event name" do
    let(:new_name) { "" }

    it "raises an error" do
      expect { subject }.to raise_error(ActiveRecord::RecordInvalid)
    end
  end
end
