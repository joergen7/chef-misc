#
# Cookbook Name:: chef-misc
# Recipe:: effi
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

effi_githuburl = "https://github.com/joergen7/effi.git"
effi_vsn = "master"
effi_dir = "#{node.dir.software}/effi-0.1.0"

include_recipe "chef-misc::rebar3"
include_recipe "chef-misc::getopt"

git "git_clone_effi" do
  action :sync
  repository effi_githuburl
  destination effi_dir
  revision effi_vsn
end

bash "compile_effi" do
  code "rebar3 compile"
  cwd effi_dir
  # not_if "#{File.exists?( "#{effi_dir}/ebin/effi.beam" )}"
end

link "/usr/local/lib/erlang/lib/effi-0.1.0" do
  to "#{effi_dir}/ebin"
end

link "#{node.dir.bin}/effi" do
  to "#{effi_dir}/priv/effi"
end
