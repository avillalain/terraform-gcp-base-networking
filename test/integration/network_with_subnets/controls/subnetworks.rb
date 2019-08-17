# frozen_string_literal: true
project_id = attribute('project_id')
subnetworks = attribute('source_subnetworks')

include_controls 'network-baseline'
include_controls 'outputs' do
  skip_control 'routes-output'
end

control 'inspec-gcp-subnetwork' do
  title "Google Cloud Configuration"

  subnetworks.each do |subnetwork|
    describe google_compute_subnetwork(project: project_id, name: subnetwork['name'], region: subnetwork['region']) do
      it { should exist }
      its('ip_cidr_range') { should eq subnetwork['cidr_range'] }
      its('private_ip_google_access') { should be subnetwork['private_access'] }
      its('region') { should end_with subnetwork['region'] }
    end
  end
end

control "gcloud-subnetwork" do
  title "Google Cloud Configuration"

  subnetworks.each do |subnetwork|
    describe command("gcloud compute networks subnets describe #{subnetwork['name']} --region=#{subnetwork['region']} \
    --project=#{project_id} --format=json") do
      let(:data) do
        if subject.exit_status == 0
          JSON.parse(subject.stdout)
        else
          {}
        end
      end

      describe "description" do
        it "should be #{subnetwork['description']}" do
          expect(data).to include(
            "description" => subnetwork['description']
          )
        end
      end

      describe "enable_flow_logs" do
        it "should be #{subnetwork['enable_flow_logs']}" do
          expect(data).to include(
            "enableFlowLogs" => subnetwork['enable_flow_logs']
          )
        end
      end

      describe "secondary_ip_ranges" do
        it "should match #{subnetwork['secondary_ranges']} content" do
          if subnetwork['secondary_ranges'].any?
            expect(data).to include(
              "secondaryIpRanges" => subnetwork['secondary_ranges'].map do |secondary_range|
                { "ipCidrRange" => secondary_range['cidr_range'], "rangeName" => secondary_range['name'] }
              end
            )
          end
        end
      end
    end
  end
end
