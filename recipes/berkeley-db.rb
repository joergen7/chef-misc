#
# Cookbook Name:: chef-misc
# Recipe:: berkeley-db
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

db_link   = "http://download.oracle.com/berkeley-db/db-4.8.30.tar.gz"
db_tar    = "#{node["dir"]["archive"]}/#{File.basename( db_link )}"



# directories
directory node["dir"]["archive"]
directory node["dir"]["software"]

# packages
package "g++"

remote_file db_tar do
  action :create_if_missing
  source db_link
end

bash "extract_db" do
  code "tar xf #{db_tar} -C #{node["dir"]["software"]}"
  creates node["db"]["dir"]
end

bash "compile_db" do
  code <<-SCRIPT
mkdir #{node["db"]["prefix"]}
../dist/configure --disable-shared --enable-cxx --with-pic --prefix=#{node["db"]["prefix"]}
make install
  SCRIPT
  cwd "#{node["db"]["dir"]}/build_unix"
  creates "#{node["db"]["dir"]}/build_unix/Makefile"
end

