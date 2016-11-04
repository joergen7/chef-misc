#
# Cookbook Name:: chef-misc
# Recipe:: rebar
#
# Copyright (c) 2015 Jörgen Brandt, All Rights Reserved.

include_recipe "chef-misc::erlang"


rebar_githuburl = "https://github.com/erlang/rebar3.git"
rebar_vsn = "3.3.2"
rebar_dir = "#{node["dir"]["software"]}/rebar3-#{rebar_vsn}"


# packages
package "git"


# directories
directory node["dir"]["software"]

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
  creates "#{rebar_dir}/rebar3"
end

# create link
link "#{node["dir"]["bin"]}/rebar3" do
    to "#{rebar_dir}/rebar3"
end
