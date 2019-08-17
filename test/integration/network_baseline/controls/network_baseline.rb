# frozen_string_literal: true
project_id = attribute('project_id')
network_name = attribute('network_name')
description = attribute('description')

control 'inspec-gcp-network-baseline' do
  title 'Google Compute Network Configuration'

  describe google_compute_network(project: project_id, name: network_name) do
    it { should exist }
    its('name') { should eq network_name }
    its('auto_create_subnetworks') { should be false }
  end
end

control 'gcloud-network-baseline' do
  describe command("gcloud compute networks describe #{network_name} --project=#{project_id} --format=json") do
    let(:data) do
      if subject.exit_status == 0
        JSON.parse(subject.stdout)
      else
        {}
      end
    end

    describe 'description' do
      it "should be #{description}" do
        expect(data).to include(
          'description' => description
        )
      end
    end
  end
end
