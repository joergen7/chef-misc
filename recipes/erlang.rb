# coding: utf-8
#
# Cookbook Name:: chef-misc
# Recipe:: erlang
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

erlang_githuburl = "https://github.com/erlang/otp.git"
erlang_vsn = node["erlang"]["vsn"]
emulator_vsn = (erlang_vsn.to_f-11).to_s
erlang_link = "http://www.erlang.org/download/otp_src_#{erlang_vsn}.tar.gz"
erlang_tar  = "#{node["dir"]["archive"]}/#{File.basename( erlang_link )}"
erlang_dir  = "#{node["dir"]["software"]}/otp-#{erlang_vsn}"

# dependent recipes
include_recipe "chef-misc::java"

# directories
directory node["dir"]["archive"]
directory node["dir"]["software"]

# packages
package "autoconf"
package "fop"
package "libgtk-3-dev"
package "libncurses5-dev"
package "libqt5opengl5-dev"
package "libssl-dev"
package "libwxbase3.0-dev"
package "libwxgtk3.0-dev"
package "libxml2-utils"
package "unixodbc-dev"
package "xsltproc"

git "git_clone_erlang" do
  action :sync
  repository erlang_githuburl
  destination erlang_dir
  revision "OTP-#{erlang_vsn}"
  timeout 2400
end

bash "autoconf_erlang" do
    code "./otp_build autoconf"
    cwd erlang_dir
    creates "#{erlang_dir}/configure"
end

bash "configure_erlang" do
    code "./configure"
    cwd erlang_dir
    creates "#{erlang_dir}/Makefile"
end

bash "compile_erlang" do
    code "make"
    cwd erlang_dir
    creates "#{erlang_dir}/bin/erl"
end

bash "install_erlang" do
    code "make install"
    cwd erlang_dir
    not_if "#{`erl -version 2>&1`.strip().end_with?( "emulator version #{emulator_vsn}" )}"
end
