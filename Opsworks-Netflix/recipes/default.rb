#
# Cookbook Name:: netflix
# Recipe:: default
#
# Copyright 2015, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

# Update all base packages 
execute 'update-all' do
  command 'yum update -y'
  creates '/tmp/something'
  action :run
end

# Install docker 
package 'docker' do
  action :install
end

# Install git
package 'git' do
  action :install
end

#Create the source files : preprocess
cookbook_file '/home/ec2-user/preprocess.py' do
  source 'preprocess.py'
  owner 'root'
  group 'root'
  mode '0777'
end

#Create the source files : Dockerfile
cookbook_file '/home/ec2-user/Dockerfile' do
  source 'Dockefile'
  owner 'root'
  group 'root'
  mode '0777'
end

#Create the source files : supervisord
directory '/home/ec2-user/supervisord' do
  owner 'root'
  group 'root'
  mode '0755'
  action :create
end

#Create the source files : supervisord/haproxy.conf
cookbook_file '/home/ec2-user/supervisord/haproxy.conf' do
  source 'haproxy.conf'
  owner 'root'
  group 'root'
  mode '0644'
end

#Create the source files : supervisord/dnsmasq.conf
cookbook_file '/home/ec2-user/supervisord/dnsmasq.conf' do
  source 'dnsmasq.conf'
  owner 'root'
  group 'root'
  mode '0644'
end

#Please ensure you are using a fixed EIP before running the preprocess.py
execute 'preprocess.py' do
  command 'python /home/ec2-user/preprocess.py'
  creates '/tmp/something'
  action :run
end

#Now build the docker image 
execute 'Docker Build' do
  command 'docker build -t aws/netflix-ec2 /home/ec2-user/.'
  creates '/tmp/something'
  action :run
end

#Now run the resutling container
execute 'docker-ec2 start' do
  command 'docker run -p 53:53/udp -p 80:80 -p 443:443 -d aws/netflix-ec2'
  creates '/tmp/something'
  action :run
end


