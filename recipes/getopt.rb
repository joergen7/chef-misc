#
# Cookbook Name:: chef-misc
# Recipe:: getopt
#
# Copyright (c) 2016 Jörgen Brandt, All Rights Reserved.

getopt_githuburl = "https://github.com/jcomellas/getopt.git"
getopt_vsn = "v0.8.2"
getopt_dir = "#{node.dir.software}/getopt-0.8.2"

include_recipe "chef-misc::rebar"

git "git_clone_getopt" do
  repository getopt_githuburl
  destination getopt_dir
  revision getopt_vsn
end

bash "compile_getopt" do
  code "rebar co"
  cwd getopt_dir
  not_if "#{File.exists?( "#{getopt_dir}/ebin/getopt.beam" )}"
end

link "/usr/local/lib/erlang/lib/getopt-0.8.2" do
  to "#{getopt_dir}/ebin"
end
