#
# Cookbook Name:: chef-misc
# Recipe:: berkeley-db
#
# Copyright (c) 2015 Jörgen Brandt, All Rights Reserved.

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

