# frozen_string_literal: true
project_id = attribute('project_id')
routes = attribute('source_routes')

include_controls 'network-baseline'
include_controls 'outputs' do
  skip_control 'subnetworks-output'
end

control 'inspec-gcp-routes' do
  title "Google Cloud Configuration"

  routes.each do |route|
    describe google_compute_route(project: project_id, name: route['name']) do
      it { should exist }
      its('dest_range') { should eq route['destination_range'] }
      its('description') { should eq route['description'] }
      its('tags') { should eq route['tags'] }
      its('next_hop_gateway') { should end_with(route['internet'] ? 'default-internet-gateway' : '') }
      its('next_hop_instance') { should eq(route['hop_instance'] ? route['hop_instance'] : nil) }
      its('next_hop_ip') { should eq(route['hop_ip'] ? route['hop_ip'] : nil) }
      its('next_hop_vpn_tunnel') { should eq(route['hop_vpn'] ? route['hop_vpn'] : nil) }
      its('priority') { should eq(route['priority'].to_i) }
    end
  end
end
