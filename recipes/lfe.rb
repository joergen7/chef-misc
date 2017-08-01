#
# Cookbook Name:: chef-misc
# Recipe:: lfe
#
# Copyright (c) 2016 Jörgen Brandt, All Rights Reserved.

lfe_githuburl = "https://github.com/rvirding/lfe.git"
lfe_vsn = "1.3"
lfe_dir = "#{node["dir"]["software"]}/lfe-#{lfe_vsn}"

# include_recipe "chef-misc::rebar3"
include_recipe "chef-misc::erlang"

package "git"
package "pandoc"

directory node["dir"]["software"]

git "git_clone_lfe" do
  action :checkout
  repository lfe_githuburl
  destination lfe_dir
  revision lfe_vsn
end

bash "compile_lfe" do
  code "make"
  cwd lfe_dir
  not_if "#{File.exists?( "#{lfe_dir}/bin/lfe" )}"
end

bash "install_lfe" do
  code "make install"
  cwd lfe_dir
  not_if "#{File.exists?( "/usr/local/bin/lfe" )}"
end