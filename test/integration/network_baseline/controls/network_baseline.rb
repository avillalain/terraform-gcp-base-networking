# frozen_string_literal: true
project_id = attribute('project_id')
network = attribute('network')

control 'inspec-gcp-network-baseline' do
  title 'Google Compute Network Configuration'

  describe google_compute_network(project: project_id, name: network['name']) do
    it { should exist }
    its('name') { should eq network['name'] }
    its('auto_create_subnetworks') { should be false }
  end
end

control 'gcloud-network-baseline' do
  describe command("gcloud compute networks describe #{network['name']} --project=#{project_id} --format=json") do
    let(:data) do
      if subject.exit_status == 0
        JSON.parse(subject.stdout)
      else
        {}
      end
    end

    describe 'description' do
      it "should be #{network['description']}" do
        expect(data).to include(
          'description' => network['description']
        )
      end
    end
  end

  describe "network output" do
    it 'has a non empty self_link property' do
      expect(network['self_link']).to_not be_empty
    end
  end
end
