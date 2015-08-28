#
# Cookbook Name:: erlang
# Recipe:: default
#
# Copyright (c) 2015 Jörgen Brandt, All Rights Reserved.


# refresh package sources
bash "apt-get_update" do
    code "apt-get update"
end

# directories
directory node.archive
directory node.software

# packages
package "fop"
package "libgtk-3-dev"
package "libncurses5-dev"
package "libqt5opengl5-dev"
package "libssl-dev"
package "libwxbase3.0-dev"
package "libwxgtk3.0-dev"
package "libxml2-utils"
package "openjdk-#{node.java.version}-jdk"
package "unixodbc-dev"
package "xsltproc"

# erlang
erlang_tar  = "#{node.archive}/#{File.basename( node.erlang.link )}"
erlang_dir  = "#{node.software}/otp_src_#{node.erlang.version}"

remote_file erlang_tar do
    action :create_if_missing
    source node.erlang.link
end

bash "extract_erlang" do
    code "tar xf #{erlang_tar} -C #{node.software}"
    not_if "#{Dir.exists?( erlang_dir )}"
end

bash "configure_erlang" do
    code "./configure"
    cwd erlang_dir
    not_if "#{File.exists?( "#{erlang_dir}/Makefile" )}"
end

bash "compile_erlang" do
    code "make"
    cwd erlang_dir
    not_if "#{File.exists?( "#{erlang_dir}/bin/erl" )}"
end

bash "install_erlang" do
    code "make install"
    cwd erlang_dir
    not_if "#{File.exists?( "/usr/local/bin/erl" )}"
end
