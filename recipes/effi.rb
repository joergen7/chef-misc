#
# Cookbook Name:: chef-misc
# Recipe:: effi
#
# Copyright (c) 2016 The Authors, All Rights Reserved.

effi_githuburl = "https://github.com/joergen7/effi.git"
effi_vsn = "master"
effi_dir = "#{node.dir.software}/effi-0.1.0"

include_recipe "chef-misc::getopt"

git "git_clone_effi" do
  action :sync
  repository effi_githuburl
  destination effi_dir
  revision effi_vsn
end

bash "compile_effi" do
  code "rebar co"
  cwd effi_dir
  # not_if "#{File.exists?( "#{effi_dir}/ebin/effi.beam" )}"
end

link "/usr/local/lib/erlang/lib/effi-0.1.0" do
  to "#{effi_dir}/ebin"
end

link "#{node.dir.bin}/effi" do
  to "#{effi_dir}/priv/effi"
end
