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
control 'packages installed' do
  impact 0.5
  describe package('%%MYSQL_SERVER_PACKAGE_NAME%%') do
    it { should be_installed }
  end
  describe package('%%MYSQL_SHELL_PACKAGE_NAME%%') do
    it { should be_installed }
  end
end
control 'packages correct version' do
  impact 0.5
  describe package('%%MYSQL_SERVER_PACKAGE_NAME%%') do
    its ('version') { should match '%%MYSQL_SERVER_VERSION%%.*' }
  end
  describe package('%%MYSQL_SHELL_PACKAGE_NAME%%') do
    its ('version') { should match '%%MYSQL_SHELL_VERSION%%.*' }
  end
  only_if {%%TEST_VERSION%%}
end
