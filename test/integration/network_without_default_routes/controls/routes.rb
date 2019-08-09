# frozen_string_literal: true
project_id = attribute('project_id')

include_controls 'network-baseline'
include_controls 'outputs' do
  skip_control 'subnetworks-output'
end

control 'inspec-gcp-routes' do
  describe google_compute_routes(project: project_id) do
    its('count') do
      should be(0)
    end
  end
end
