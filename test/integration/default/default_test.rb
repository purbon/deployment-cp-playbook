
describe service('confluent-server') do
  it { should be_running.under('systemd') }
end
