#
# Cookbook Name:: chef-misc
# Recipe:: bitcoin
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



include_recipe "chef-misc::berkeley-db"

# bitcoin
bitcoin_githuburl = "https://github.com/bitcoin/bitcoin.git"
bitcoin_vsn = node["bitcoin"]["vsn"]
bitcoin_dir = "#{node["dir"]["software"]}/bitcoin-#{bitcoin_vsn}"

# directories
directory node["dir"]["software"]

# packages
package "autoconf"
package "git"
package "libboost-all-dev"
package "libprotobuf-dev"
package "qttools5-dev"
package "qttools5-dev-tools"
package "libtool"
package "miniupnpc"
package "pkg-config"
package "protobuf-compiler"
package "libevent-dev"




git "git_clone_bitcoin" do
  action :checkout
  repository bitcoin_githuburl
  destination bitcoin_dir
  revision "v#{bitcoin_vsn}"
end

bash "compile_bitcoin" do
  code <<-SCRIPT
./autogen.sh
./configure CPPFLAGS="-I#{node["db"]["prefix"]}/include/ -O2" LDFLAGS="-L#{node["db"]["prefix"]}/lib/" --with-gui
make install
  SCRIPT
  cwd bitcoin_dir
  creates "#{bitcoin_dir}/src/qt/bitcoin-qt"
end
