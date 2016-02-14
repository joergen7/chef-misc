#
# Cookbook Name:: chef-misc
# Recipe:: eqc
#
# Copyright (c) 2016 Jörgen Brandt, All Rights Reserved.

eqc_vsn = "2.01.0"
eqc_zip = "#{node.dir.archive}/eqcmini-#{eqc_vsn}.zip"
eqc_dir = "#{node.dir.software}/eqcmini-#{eqc_vsn}"

include_recipe "chef-misc::erlang"

directory node.dir.archive
directory node.dir.software

cookbook_file eqc_zip do
  source "eqcmini-#{eqc_vsn}.zip"
end

bash "extract_eqc" do
  code "unzip -o #{eqc_zip} -d #{eqc_dir}"
end

link "/usr/local/lib/erlang/lib/eqc-#{eqc_vsn}" do
  to "#{eqc_dir}/eqc-#{eqc_vsn}"
end

