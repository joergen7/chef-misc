#
# Cookbook Name:: chef-misc
# Recipe:: riak
#
# Copyright (c) 2015 Jörgen Brandt, All Rights Reserved.

riak_vsn = "2.1.2"
riak_dir = "#{node.dir.software}/riak-#{riak_vsn}"
riak_githuburl = "https://github.com/basho/riak.git"

# build dependencies
include_recipe "chef-misc::erlang"

# install required packages
package "git"

# create directories
directory node.dir.software

# clone riak from git
git "git_clone_riak" do
  action :checkout
  repository riak_githuburl
  destination riak_dir
  revision riak_vsn
end

# build riak dependencies
#bash "build_riak_deps" do
#  code "make locked-deps"
#  cwd riak_dir
#  not_if ""
#end
  
#bash "build_riak" do
#  code "make rel"
#  cwd riak_dir
#  not_if ""
#end

