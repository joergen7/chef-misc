#
# Cookbook Name:: chef-misc
# Recipe:: bitcoin
#
# Copyright (c) 2015 Jörgen Brandt, All Rights Reserved.



include_recipe "chef-misc::berkeley-db"

# bitcoin
bitcoin_githuburl = "https://github.com/bitcoin/bitcoin.git"
bitcoin_vsn = "v0.14.1"
bitcoin_dir = "#{node["dir"]["software"]}/bitcoin-#{bitcoin_vsn[1,7]}"

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
  revision bitcoin_vsn
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
