# frozen_string_literal: true.
subnetworks = attribute('subnetworks')
network = attribute('network')
routes = attribute('routes')

RSpec::Matchers.define :be_boolean do
  match do |actual|
    expect(actual).to be_in([true, false])
  end
end

control 'network-output' do
  describe 'networks' do
    it 'should return a network object with additional self_link' do
      expect(network).to match(
        "self_link" => an_instance_of(String),
        "name" => an_instance_of(String),
        "routing_mode" => an_instance_of(String),
        "delete_default_routes" => be_boolean,
        "description" => an_instance_of(String)
      )
    end
  end
end

control 'subnetworks-output' do
  describe 'subnetworks' do
    it 'should return a subnetwork object with additional self_link' do
      expect(subnetworks).to include(
        "self_link" => an_instance_of(String),
        "name" => an_instance_of(String),
        "cidr_range" => an_instance_of(String),
        "region" => an_instance_of(String),
        "private_access" => be_boolean,
        "description" => an_instance_of(String),
        "enable_flow_logs" => be_boolean,
        "secondary_ranges" => an_instance_of(Array)
      )
    end
  end
end

control 'routes-output' do
  describe 'routes' do
    it 'should return a route object with additional self_link' do
      routes.each do |route|
        expect(route).to match(
          "self_link" => an_instance_of(String),
          "name" => an_instance_of(String),
          "description" => an_instance_of(String),
          "tags" => all(an_instance_of(String)),
          "destination_range" => an_instance_of(String),
          "next_hop_type" => an_instance_of(String),
          "next_hop" => an_instance_of(String),
          "priority" => an_instance_of(Integer)
        )
      end
    end
  end
end
