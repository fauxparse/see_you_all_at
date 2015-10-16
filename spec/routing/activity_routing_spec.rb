require "rails_helper"

describe "Routing" do
  class RouteTester
    include Rails.application.routes.url_helpers
  end

  before do
    Rails.application.routes.default_url_options[:host] = "seeyouall.at"
  end

  let(:routes) { RouteTester.new }
  let(:event) { FactoryGirl.create(:event, name: "Festival") }
  let(:type) { FactoryGirl.create(:activity_type, event: event, name: "Party") }

  let(:activity) do
    FactoryGirl.create(:activity, name: "Fun", activity_type: type)
  end

  let(:path) do
    "/events/#{event.slug}/activities/#{type.slug}/#{activity.slug}"
  end

  describe "#activity_path" do
    subject { routes.activity_path(activity) }
    it { is_expected.to eq(path) }
  end

  describe "#activity_url" do
    subject { routes.activity_url(activity) }
    it { is_expected.to eq("http://seeyouall.at#{path}") }
  end

  describe "#event_activity_path" do
    subject { routes.event_activity_path(event, activity) }
    it { is_expected.to eq(path) }
  end

  describe "#event_activity_url" do
    subject { routes.event_activity_url(event, activity) }
    it { is_expected.to eq("http://seeyouall.at#{path}") }
  end

  describe "#edit_activity_path" do
    subject { routes.edit_activity_path(activity) }
    it { is_expected.to eq(path + "/edit") }
  end

  describe "#edit_activity_url" do
    subject { routes.edit_activity_url(activity) }
    it { is_expected.to eq("http://seeyouall.at#{path}/edit") }
  end
end
