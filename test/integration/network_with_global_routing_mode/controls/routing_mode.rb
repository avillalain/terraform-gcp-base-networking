# frozen_string_literal: true
project_id = attribute('project_id')
network = attribute('network')

include_controls 'network-baseline'

include_controls 'outputs' do
  skip_control 'subnetworks-output'
  skip_control 'routes-output'
end

control 'inspec-gcp-global-routing-mode' do
  describe google_compute_network(project: project_id, name: network['name']) do
    its('routing_config.routing_mode') { should eq 'GLOBAL' }
  end
end
