#
# Cookbook Name:: chef-misc
# Recipe:: lfe
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

lfe_githuburl = "https://github.com/rvirding/lfe.git"
lfe_vsn = node["lfe"]["vsn"]
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