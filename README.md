# Terraform GCP Base Network Module

A Terraform module for building a base network in GCP.

It supports the creation of:
- Google Virtual Private Network (VPC)
- Subnets within the VPC
  - Secondary ranges can be specified per each subnetwork
- Routes within the VPC

## Compatibility

This module is meant for use with Terraform 0.12. Please refer to the [upgrade guide](https://www.terraform.io/upgrade-guides/0-12.html) for more information.

## Usage
Have a look at the examples inside the test fixture folder. However, you can incluided something like the following in your terraform configuration:

```hcl
module "network" {
    source  = "terraform-google-modules/network/google"
    version = "~> 0.1.0"
    network {
        name = "example-network"
        routing_mode = "GLOBAL"
        delete_default_routes = true
        description = "a description"
    }
    subnetworks = [
        {
            name = "example-subnetwork"
            description = "another description"
            cidr_range = "10.0.0.0/24"
            private_access = true
            region = "us-east1"
            enable_flow_logs = true
            secondary_ranges = [
                {
                    name = "secondary-range"
                    cidr_range = "192.168.64.0/24"
                }
            ]
        }
    ]
    routes = [
        {
            name = "egress-internet"
            description = "again, another description"
            tags = ["egress-inet"]
            destination_range = "10.50.10.0/24"
            next_hop_type = "DEFAULT
            next_hop = "default-internet-gateway"
            priority = "1000"
        }
    ]
}
```

## Inputs

As you can see from the above snippet there are three main inputs

| Field | Description | Type | Required |
|-------|-------------|------|----------|
| network | An object that provides all configuration parameters associated with the vpc. | object | true |
| subnetworks | A list of subnetwork configuration objects that holds all configuration parameters associated to a subnetwork | list(object) | false (default empty list) |
| routes | A list of routes configurations objects that describe each route to be provisioned. | list(object) | false (default empty list) |

As of Terraform 0.12.6, there is no way of specifying optional parameters for an object. So for that reason all parameters of each object are required. Only way to avoid specifying something is by simply declared them empty or null.

### Network Inputs

| Field | Description | Type |
|-------|-------------|------|
| name | the name of the network being created. | string |
| routing\_mode | the network routing mode. Either 'GLOBAL' or 'REGIONAL'. | string |
| delete\_default\_routes | If set to `true`, default routes (`0.0.0.0/0`) will be deleted inmediately after network creation. | bool |
| description | A description of this resource. | string |

### Subnetwork Inputs

| Field | Description | Type |
|-------|-------------|------|
| name | the name of the subnetwork resource. | string |
| description | A description of this resource. | string |
| cidr\_range | The range of addresses owned by this subnetwork. | string |
| private\_access | If set to `true`, VMs in this subnetwork can access Google APIs and services using Private Google Access. | bool |
| region | The region for this subnetwork. | string |
| enable\_flow\_logs | Whether to enable flow logging for the subnetwork being created. | bool |
| secondary\_ranges | An object that provides an array of combinations for secondary IP ranges for this subnetwork | object |

### Secondary Ranges Input

| Field | Description | Type |
|-------|-------------|-------|
| name | the name for this new range of IP address belonging to a subnetwork. | string |
| cidr_range | the range of IP address for a secondary range. | string |

### Routes Input

| Field | Description | Type |
|-------|-------------|------|
| name | the name for the route resource. | string |
| description | a description for this resource. | string |
| tags | a list of tags for this route | list(string) |
| destination\_range | the range of outgoing packets that this route applies to. | string |
| next\_hop\_type | An enum that specify if the next hop is the default internet gateway, a vpn tunnel, an instance or the network IP address of an instance. <br/> - Use `DEFAULT` if the next hop should be a gateway. <br/> - Use `INSTANCE` if the next hop is a instance. <br/> - Use `IP_ADDR` if the next_hop is going to be the ip address of an instance. <br/> - Use `VPN` if the next hop is a VPN tunnel. | string |
| next\_hop | Either the URL of the resources (like instance URL, or a VPN Tunner resource URL) or `default-internet-gateway`. | string |
| priority | the prioerity of this route, used to break ties in cases there are more than one matching route. | string |

## Outputs

The output of this module are the same content as the inputs, plus the `self_link` of the created resources

## File structure
The project has the following folders and files:

- /: root folder
- /test/fixtures: The fixture for our test harness, but it also serves as examples on how to use this module
- /test: Folders with files for testing the module
- /main.tf: main file for this module, contains all the resources to create
- /variables.tf: all the variables for the module
- /output.tf: the outputs of the module

## Testing and documentation generation

### Requirements
- [kitchen-terraform](https://github.com/newcontext-oss/kitchen-terraform)
- [inspec-gcp](https://www.inspec.io/)
- [gcloud](https://cloud.google.com/sdk/gcloud/)
- Ruby 2.6.2
- Bundler

### Testing

First install all requirments:

        bundle install --binstubs

Install and configure your [gcloud-sdk](https://cloud.google.com/sdk/gcloud/). Create a google project, and store the `project id` in an environmental variable called `GOOGLE_PROJECT_ID`. You must also have a `Service` account with the following roles:
- `Compute Network Admin`

After that, configure the service account with the roles documented above and export the JSON key. Create an enviromentable variable called `GOOGLE_APPLICATION_CREDENTIALS` and store the path location pointing to the JSON key.

Once that is done, execute the following command to run the test:

        TF_VAR_project_id=$GOOGLE_PROJECT_ID kitchen test

## Collaboration

Everyone is welcome to collaborate and propose ideas. In fact I would love to hear from your input and recommendations. I'm fairly new to ruby and I would love your feedback! Also if you find anything funky with the documentation so far feel free to point it out, English is not my first language. 
