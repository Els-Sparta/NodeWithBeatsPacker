#
# Cookbook:: beats
# Recipe:: default
#
# Copyright:: 2018, The Authors, All Rights Reserved.

# Update the sources list
apt_update("update") do
  action :update
end

# Install transport-https for installation
package("apt-transport-https") do
  action :install
end

# Get the source for the package to install
bash("wget_elastic") do
  code "wget -qO - https://artifacts.elastic.co/GPG-KEY-elasticsearch | sudo apt-key add -"
  action :run
end

apt_repository("elastic-co") do
  uri "https://artifacts.elastic.co/packages/6.x/apt"
  distribution "stable"
  components ["main"]
  action :add
end

# Update the sources list
apt_update("update") do
  action :update
end

# Install filebeat
package("filebeat") do
  action :install
end

# Install metricbeat
package("metricbeat") do
  action :install
end

file("/etc/filebeat/filebeat.yml")do
  action :delete
end

file("/etc/metricbeat/metricbeat.yml") do
  action :delete
end

template( "/etc/filebeat/filebeat.yml") do
  source "filebeat.yml.erb"
end

template("/etc/metricbeat/metricbeat.yml") do
  source "metricbeat.yml.erb"
end

service("filebeat") do
  action [:enable, :start]
end

service("metricbeat") do
  action [:enable, :start]
end
