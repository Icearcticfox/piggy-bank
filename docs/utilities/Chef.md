
### Example test VM cookbook with mock parameters

run in directory `<cookbooks>/spec/<>.rb`

```
require 'chefspec'  
  
  
class File  
  def self.exists?(path)  
    exist?(path)  
  end  
end  
  
  
  
module PerimeterHelper  
  def self.preprod?  
    'test'  
  end  
  
  def self.environment  
    'preprod'  
  end  
  
  def self.under_test?  
    true  
  end  
end  
  
  
module CriteoInfra  
  module Device  
    def self.owners  
      'gu-tests'  
    end  
  end  
  
  def self.datacenter  
    'datacenter-1'  
  end  
  
  def self.environment  
    'preprod'  
  end  
end  
  
RSpec.configure do |config|  
  config.cookbook_path = [  
    '../chef-configuration/policies/observability/victoriametrics/cookbooks/',  
    '../chef-configuration/policies/observability/shared-cookbooks/',  
    '../.chef-workstation/cache/cookbooks/',  
    '../criteo/chef-configuration/policies/hardware/inventory/cookbooks/base-inventory/'  
  ]  
  
  config.before(:each) do  
      vault_items = {  
        ['secrets', 'victoriametrics_backup_preprod'] => { 'access_key' => 'mock_access_key', 'secret_key' => 'mock_secret_key' },  
        ['secrets', 'consul_acl_storage_preprod'] => { 'consul_token' => 'mocked_consul_token' }  
      }  
      allow_any_instance_of(Chef::DSL::Secret).to receive(:chef_vault_item) do |instance, *args|  
        puts "chef_vault_item called with args: #{args.inspect}"  
        result = vault_items[args] || nil  
        puts "chef_vault_item called with args: #{args.inspect}, returning: #{result.inspect}"  
        result  
    end  
    allow_any_instance_of(Chef::DSL::Secret).to receive(:secret)  
      .and_return('consul_criteo' => { 'acl_token' => 'mocked_acl_token' })  
  
    stub_const('CriteoBase', Module.new)  
    stub_const('CriteoBase::DNS', Module.new)  
  
    allow(CriteoBase::DNS).to receive(:service_zone).and_return('default_service_zone')  
    allow(CriteoBase::DNS).to receive_message_chain(:consul_alias).and_return(nil)  
  end  
end  
  
  
describe 'policy-victoriametrics::default' do  
  let(:env) { 'preprod' }  
  before do  
    allow(::CriteoInfra).to receive(:environment).and_return(env)  
    allow_any_instance_of(Chef::DSL::Secret).to receive(:chef_vault_item).and_call_original  
  
    expect_any_instance_of(Chef::DSL::Secret).to receive(:chef_vault_item)  
      .with('secrets', "consul_acl_storage_#{env}")  
      .and_return('consul_token' => 'mocked_consul_token')  
  end  
  
  let(:chef_run) do  
    # Creating a simulation of chef-client execution with the necessary attributes  
    ChefSpec::SoloRunner.new(platform: 'ubuntu', version: '18.04') do |node|  
      node.normal['victoriametrics']['vmagent']['enabled'] = true  
      node.normal['victoriametrics']['vmagent']['custom_flags'] = '--some-flag'  
      node.normal['victoriametrics']['vmagent']['http_address'] = ':8429'  
      node.normal['victoriametrics']['vmagent']['graphite_address'] = ':2003'  
      node.normal['victoriametrics']['vmagent']['spool_dir'] = '/opt/vmagent/spool'  
      node.normal['victoriametrics']['vmagent']['memory_allowed_percent'] = 60  
      node.normal['victoriametrics']['vmagent']['remotewrite_show_url'] = true  
      node.normal['victoriametrics']['vmagent']['remotewrite_queues'] = 80  
      node.normal['victoriametrics']['vmagent']['remotewrite_max_block_size'] = 83886080  
      node.normal['consul_criteo']['acl_token'] = 'mocked_acl_token'  
      node.normal['os_criteo']['hostname'] = 'mocked-hostname'  
      node.normal['victoriametrics']['vmagent']['remotewrite_max_rows_per_block'] = 100000  
      node.normal['victoriametrics']['vmagent']['spool_max_disk_usage'] = 48  
      node.normal['victoriametrics']['vmagent']['remotewrite_multitenant'] = [  
        { 'url' => "http://testconsul", 'relabel_type' => 'short', 'diskSpooling' => false }  
      ]  
    end.converge('policy-victoriametrics::service')  
  end  
  
  before do  
    chef_run.resource_collection.insert(  
      Chef::Resource::Service.new('consul', chef_run.run_context)  
    )  
  end  
  
  it 'creates the correct command for vmagent' do  
  expected_params = "--some-flag " \  
                    "--httpListenAddr=:8429 " \  
                    "--graphiteListenAddr=:2003 " \  
                    "--remoteWrite.tmpDataPath=/opt/vmagent/spool " \  
                    "--memory.allowedPercent=60 " \  
                    "--remoteWrite.showURL=true " \  
                    "--remoteWrite.queues=80 " \  
                    "--remoteWrite.maxBlockSize=83886080 " \  
                    "--remoteWrite.maxRowsPerBlock=100000 " \  
                    "--remoteWrite.maxDiskUsagePerURL=48GB " \  
                    "--remoteWrite.url=http://testconsul " \  
                    "--remoteWrite.urlRelabelConfig=/opt/vmagent/conf/rw_relabel_short.yml " \  
                    '--remoteWrite.disableOnDiskQueue=true '  
  
  actual_params = chef_run.node['services']['vmagent']['params']  
  
  puts "Expected: #{expected_params.inspect}"  
  puts "Actual: #{actual_params.inspect}"  
  
  expect(actual_params.strip).to eq(expected_params.strip)  
end  
end
```

