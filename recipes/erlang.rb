# coding: utf-8
#
# Cookbook Name:: chef-misc
# Recipe:: erlang
#
# Copyright (c) 2015 Jörgen Brandt, All Rights Reserved.


java_vsn = "7"
erlang_vsn = "18.2"
erlang_link = "http://www.erlang.org/download/otp_src_#{erlang_vsn}.tar.gz"
erlang_tar  = "#{node.dir.archive}/#{File.basename( erlang_link )}"
erlang_dir  = "#{node.dir.software}/otp_src_#{erlang_vsn}"

# directories
directory node.dir.archive
directory node.dir.software

# packages
package "fop"
package "libgtk-3-dev"
package "libncurses5-dev"
package "libqt5opengl5-dev"
package "libssl-dev"
package "libwxbase3.0-dev"
package "libwxgtk3.0-dev"
package "libxml2-utils"
package "openjdk-#{java_vsn}-jdk"
package "unixodbc-dev"
package "xsltproc"


remote_file erlang_tar do
    action :create_if_missing
    source erlang_link
end

bash "extract_erlang" do
    code "tar xf #{erlang_tar} -C #{node.dir.software}"
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
