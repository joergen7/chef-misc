#
# Cookbook Name:: chef-misc
# Recipe:: cpntools
#
# Copyright (c) 2016 The Authors, All Rights Reserved.

ct_vsn = "2.3.5"
ct_link = "http://cpntools.org/downloads/cpntools_#{ct_vsn}.tar.gz"
ct_tar = "#{node["dir"]["archive"]}/#{File.basename( ct_link )}"
ct_dir = "#{node["dir"]["software"]}/CPNTools"

directory node["dir"]["archive"]
directory node["dir"]["software"]

remote_file ct_tar do
    action :create_if_missing
    source ct_link
end

bash "extract_cpntools" do
    code "tar xf #{ct_tar} -C #{node["dir"]["software"]}"
    creates ct_dir
end