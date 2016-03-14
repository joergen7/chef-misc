#
# Cookbook Name:: chef-misc
# Recipe:: bitcoin
#
# Copyright (c) 2015 Jörgen Brandt, All Rights Reserved.



include_recipe "chef-misc::berkeley-db"

# bitcoin
bitcoin_githuburl = "https://github.com/bitcoin/bitcoin.git"
bitcoin_vsn = "v0.12.0"
bitcoin_dir = "#{node.dir.software}/bitcoin-0.12.0"

# directories
directory node.dir.software

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
./configure CPPFLAGS="-I#{node.db.prefix}/include/ -O2" LDFLAGS="-L#{node.db.prefix}/lib/" --with-gui
make
  SCRIPT
  cwd bitcoin_dir
  not_if "#{File.exists?( "#{bitcoin_dir}/src/qt/bitcoin-qt" )}"
end

link "#{node.dir.bin}/bitcoin-qt" do
  to "#{bitcoin_dir}/src/qt/bitcoin-qt"
end

link "#{node.dir.bin}/bitcoind" do
  to "#{bitcoin_dir}/src/bitcoind"
end

link "#{node.dir.bin}/bitcoin-cli" do
  to "#{bitcoin_dir}/src/bitcoin-cli"
end
