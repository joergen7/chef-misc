#
# Cookbook Name:: chef-misc
# Recipe:: elixir
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

elixir_vsn = node["elixir"]["vsn"]
elixir_githuburl = "https://github.com/elixir-lang/elixir.git"
elixir_dir  = "#{node["dir"]["software"]}/elixir-#{elixir_vsn}"

include_recipe "chef-misc::erlang"

directory node["dir"]["software"]

git "git_clone_elixir" do
  action :sync
  repository elixir_githuburl
  destination elixir_dir
  revision "v#{elixir_vsn}"
end

bash "compile_elixir" do
    code "make"
    cwd elixir_dir
    creates "#{elixir_dir}/bin/elixir"
end

bash "install_elixir" do
    code "make install"
    cwd elixir_dir
    not_if "#{`elixir -v 2>&1`.strip().end_with?( "Elixir #{elixir_vsn}" )}"
end
