#
# Cookbook Name:: chef-misc
# Recipe:: rebar
#
# Copyright (c) 2015 Jörgen Brandt, All Rights Reserved.

include_recipe "chef-misc::erlang"


rebar_githuburl = "https://github.com/rebar/rebar.git"
rebar_vsn = "2.6.1"
rebar_dir = "#{node.dir.software}/rebar-#{rebar_vsn}"



# directories
directory node.dir.software

# clone rebar github repository
git "git_clone_rebar" do
  action :checkout
  repository rebar_githuburl
  destination rebar_dir
  revision rebar_vsn
end

# build rebar
bash "build_rebar" do
  code "./bootstrap"
  cwd rebar_dir
  not_if "#{File.exists?( "#{rebar_dir}/rebar" )}"
end

# create link
link "#{node.dir.bin}/rebar" do
    to "#{rebar_dir}/rebar"
end
