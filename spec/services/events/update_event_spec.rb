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

  context "with packages" do
    let(:package_1) { FactoryGirl.create(:package, event: event) }
    let(:package_2) { FactoryGirl.create(:package, event: event) }

    before { package_1 && package_2 }

    context "reordered" do
      let(:params) do
        {
          packages: {
            "0" => { id: package_2.id },
            "1" => { id: package_1.id }
          }
        }
      end

      it "updates the package positions" do
        service.call
        event.reload
        expect(event.packages.sort_by(&:position)).to eq([package_2, package_1])
      end
    end

    context "with one deleted" do
      let(:params) do
        { packages: { "0" => { id: package_2.id } } }
      end

      it "deletes the missing package" do
        expect { service.call }.to change { Package.count }.by(-1)
      end
    end

    context "with one added" do
      let(:params) do
        {
          packages: {
            "0" => { id: package_1.id },
            "1" => { id: package_2.id },
            "2" => { name: "New package" }
          }
        }
      end

      it "adds the new package" do
        expect { service.call }.to change { Package.count }.by(1)
        expect(Package.last.name).to eq("New package")
        event.reload
      end
    end
  end

  context "with package limits" do
    let(:package) { FactoryGirl.create(:package, event: event) }
    let(:activity_type) { FactoryGirl.create(:activity_type, event: event) }
    let(:params) do
      {
        packages: {
          "0" => {
            id: package.id,
            limits: { activity_type.id => 2 }
          }
        }
      }
    end

    before do
      Limit.create(package: package, activity_type: activity_type, maximum: 1)
    end

    it "updates package limits" do
      expect { service.call }.to change { Limit.first.maximum }.from(1).to(2)
    end
  end
end
