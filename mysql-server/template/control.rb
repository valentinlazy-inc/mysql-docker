control 'container' do
  impact 0.5
  describe docker_container('mysql-server-%%MAJOR_VERSION%%') do
    it { should exist }
    it { should be_running }
    its('repo') { should eq 'mysql/mysql-server' }
    its('ports') { should eq '%%PORTS%%' }
    its('command') { should match '/entrypoint.sh mysqld' }
  end
end
control 'packages' do
  impact 0.5
  describe package('mysql-community-server-minimal') do
    it { should be_installed }
    its ('version') { should match '%%MYSQL_SERVER_VERSION%%.*' }
  end
  describe package('mysql-shell') do
    it { should be_installed }
    its ('version') { should match '%%MYSQL_SHELL_VERSION%%.*' }
  end
end
