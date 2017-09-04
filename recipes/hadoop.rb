#
# Cookbook Name:: chef-misc
# Recipe:: hadoop
#
# Copyright 2015-2017 Jörgen Brandt
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

hd_group       = "hadoop"
hd_user        = "hduser"
hd_keyfile     = "/home/#{hd_user}/.ssh/id_rsa"
hd_passwd      = "Zj6j7RVkiv7pA"
hd_vsn         = "2.6.4"
hd_link        = "http://mirror.23media.de/apache/hadoop/common/hadoop-#{hd_vsn}/hadoop-#{hd_vsn}.tar.gz"
hd_tar         = "#{node["dir"]["archive"]}/#{File.basename( hd_link )}"
hd_home        = "#{node["dir"]["software"]}/hadoop-#{hd_vsn}"

# dependent recipes
include_recipe "chef-misc::java"

# directories
directory node["dir"]["archive"]
directory node["dir"]["software"]
  

bash "nn_dir" do
  code "mkdir -p #{node["hd"]["dfs"]["namenode"]["name"]["dir"]}"
  user hd_user
  creates node["hd"]["dfs"]["namenode"]["name"]["dir"]
end

bash "dn_dir" do
  code "mkdir -p #{node["hd"]["dfs"]["datanode"]["data"]["dir"]}"
  user hd_user
  creates node["hd"]["dfs"]["datanode"]["data"]["dir"]
end

# create hadoop group
group hd_group

# create hadoop user
user hd_user do
  group    hd_group
  password hd_passwd
end

# generate ssh key
bash "generate_ssh_key" do
  code    "ssh-keygen -t rsa -P \"\" -f #{hd_keyfile}"
  creates hd_keyfile
  user    hd_user
end

# authorize ssh key
bash "authorize_ssh_key" do
  code    "cat #{hd_keyfile}.pub > /home/#{hd_user}/.ssh/authorized_keys"
  creates "/home/#{hd_user}/.ssh/authorized_keys"
end

# disable ipv6
bash "disable_ipv6" do
  code <<-SCRIPT
echo '\n# disable ipv6\nnet.ipv6.conf.all.disable_ipv6 = 1\nnet.ipv6.conf.default.disable_ipv6 = 1\nnet.ipv6.lo.disable_ipv6 = 1\n' >> /etc/sysctl.conf
  SCRIPT
  not_if "grep 'net.ipv6.conf.all.disable_ipv6 = 1' /etc/sysctl.conf"
end

# download hadoop
remote_file hd_tar do
  action :create_if_missing
  source hd_link
end

# extract hadoop
bash "extract_hadoop" do
  code <<-SCRIPT
tar xf #{hd_tar} -C #{node["dir"]["software"]}
chown #{hd_user}:#{hd_group} -R #{hd_home}
  SCRIPT
  creates hd_home
end

# set JAVA_HOME
bash "bashrc_java_home" do
  code <<-SCRIPT
echo 'export JAVA_HOME=#{node["java"]["home"]}' >> /home/#{hd_user}/.bashrc
  SCRIPT
  not_if "grep 'export JAVA_HOME' /home/#{hd_user}/.bashrc"
end

# set HADOOP_HOME
bash "bashrc_hadoop_home" do
  code <<-SCRIPT
echo 'export HADOOP_HOME=#{hd_home}' >> /home/#{hd_user}/.bashrc
  SCRIPT
  not_if "grep 'export HADOOP_HOME' /home/#{hd_user}/.bashrc"
end

# set PATH
bash "bashrc_path" do
  code <<-SCRIPT
echo 'export PATH=$PATH:$HADOOP_HOME/bin:$HADOOP_HOME/sbin' >> /home/#{hd_user}/.bashrc
  SCRIPT
  not_if "grep '$HADOOP_HOME/bin' /home/#{hd_user}/.bashrc"
end

# set HADOOP_HOME aliases
bash "bashrc_hadoop_mapred_home" do
  code <<-SCRIPT
echo 'export HADOOP_MAPRED_HOME=$HADOOP_HOME\nexport HADOOP_COMMON_HOME=$HADOOP_HOME\nexport HADOOP_HDFS_HOME=$HADOOP_HOME\nexport YARN_HOME=$HADOOP_HOME' >> /home/#{hd_user}/.bashrc
  SCRIPT
  not_if "grep 'export HADOOP_MAPRED_HOME' /home/#{hd_user}/.bashrc"
end

# set HADOOP_COMMON_LIB_NATIVE_DIR
bash "bashrc_hadoop_common_lib_path" do
  code <<-SCRIPT
echo 'export HADOOP_COMMON_LIB_NATIVE_DIR=#{hd_home}/lib/native' >> /home/#{hd_user}/.bashrc
  SCRIPT
  not_if "grep 'export HADOOP_COMMON_LIB_NATIVE_DIR' /home/#{hd_user}/.bashrc"
end

# set HADOOP_OPTS
bash "bashrc_hadoop_opts" do
  code <<-SCRIPT
echo 'export HADOOP_OPTS="-Djava.library.path=$HADOOP_HOME/lib"' >> /home/#{hd_user}/.bashrc
  SCRIPT
  not_if "grep 'export HADOOP_OPTS' /home/#{hd_user}/.bashrc"
end

# hadoop-env.sh
template "#{hd_home}/etc/hadoop/hadoop-env.sh" do
  source "hadoop-env.sh.erb"
end

# core-site.xml
template "#{hd_home}/etc/hadoop/core-site.xml" do
  source "core-site.xml.erb"
end

# hdfs-site.xml
template "#{hd_home}/etc/hadoop/hdfs-site.xml" do
  source "hdfs-site.xml.erb"
end

# yarn-site.xml
template "#{hd_home}/etc/hadoop/yarn-site.xml" do
  source "yarn-site.xml.erb"
end

# mapred-site.xml
template "#{hd_home}/etc/hadoop/mapred-site.xml" do
  source "mapred-site.xml.erb"
end

