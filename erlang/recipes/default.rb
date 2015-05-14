#
# Cookbook Name:: erlang
# Recipe:: default
#
# Copyright (c) 2015 Jörgen Brandt, All Rights Reserved.


archive  = node.default.archive
software = node.default.software
bin      = "/usr/local/bin"

# refresh package sources
bash "apt-get_update" do
    code "apt-get update"
end

# directories
directory archive
directory software

# packages
package "fop"
package "libgtk-3-dev"
package "libncurses5-dev"
package "libqt5opengl5-dev"
package "libssl-dev"
package "libwxbase3.0-dev"
package "libwxgtk3.0-dev"
package "libxml2-utils"
package "openjdk-7-jdk"
package "unixodbc-dev"
package "xsltproc"

# erlang
erlang_link = "http://www.erlang.org/download/otp_src_17.5.tar.gz"
erlang_tar  = "#{archive}/#{File.basename( erlang_link )}"
erlang_dir  = "#{software}/otp_src_17.5"

remote_file erlang_tar do
    action :create_if_missing
    source   erlang_link
end

bash "extract_erlang" do
    code     "tar xf #{erlang_tar} -C #{software}"
    not_if "#{Dir.exists?( erlang_dir )}"
end

bash "configure_erlang" do
    code     "./configure"
    cwd      erlang_dir
    not_if "#{File.exists?( "#{erlang_dir}/Makefile" )}"
end

bash "compile_erlang" do
    code   "make"
    cwd    erlang_dir
    not_if "#{File.exists?( "#{erlang_dir}/bin/erl" )}"
end

link "#{bin}/erl" do
    to "#{erlang_dir}/bin/erl"
end

link "#{bin}/erlc" do
    to "#{erlang_dir}/bin/erlc"
end

link "#{bin}/dialyzer" do
    to "#{erlang_dir}/bin/dialyzer"
end
