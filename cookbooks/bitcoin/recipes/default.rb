#
# Cookbook Name:: bitcoin
# Recipe:: default
#
# Copyright (c) 2015 The Authors, All Rights Reserved.

# berkeley db
db_tar = "#{node.archive}/#{File.basename( node.db.link )}"
db_dir = "#{node.software}/db-4.8.30"
db_prefix = "#{db_dir}/build_unix/build"

# bitcoin
bitcoin_dir = "#{node.software}/bitcoin"

# refresh package sources
bash "apt-get_update_upgrade" do
  code "apt-get update"
end

# directories
directory node.archive
directory node.software

# packages
package "autoconf"
package "g++"
package "git"
package "libboost-all-dev"
package "libprotobuf-dev"
package "libqt4-dev"
package "libtool"
package "miniupnpc"
package "pkg-config"
package "protobuf-compiler"


# berkeley db

remote_file db_tar do
  action :create_if_missing
  source node.db.link
end

bash "extract_db" do
  code "tar xf #{db_tar} -C #{node.software}"
  not_if "#{Dir.exists?( db_dir )}"
end

bash "compile_db" do
  code <<-SCRIPT
mkdir #{db_prefix}
../dist/configure --enable-cxx --prefix=#{db_prefix}
make install
  SCRIPT
  cwd "#{db_dir}/build_unix"
  not_if "#{Dir.exists?( db_prefix )}"
end

# bitcoin

git "git_clone_bitcoin" do
  action :checkout
  repository node.bitcoin.githuburl
  destination bitcoin_dir
  revision node.bitcoin.version
end

bash "compile_bitcoin" do
  code <<-SCRIPT
./autogen.sh
./configure CPPFLAGS="-I#{db_prefix}/include/ -O2" LDFLAGS="-L#{db_prefix}/lib/" --with-gui
make
  SCRIPT
  cwd bitcoin_dir
end
