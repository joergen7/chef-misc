#
# Cookbook Name:: htcondor
# Recipe:: htcondor
#
# Copyright (c) 2015 The Authors, All Rights Reserved.

archive  = node.default.dir.archive


htc_link = "http://parrot.cs.wisc.edu//symlink/20150512031501/8/8.2/8.2.8/f6e3300e5123c87274f384954833cc6d/condor-8.2.8-312769-ubuntu_14.04_amd64.deb"

htc_deb = "#{archive}/#{File.basename( htc_link )}"

package "libltdl7"
package "libpython2.7"
package "libvirt0"
package "libx11-6"
package "libdate-manip-perl"

remote_file htc_deb do
    action :create_if_missing
    source htc_link
end

dpkg_package "htcondor" do
    source htc_deb
end

template "/etc/condor/condor_config" do
    source "condor_config.erb"
end

service "condor" do
    action [:enable, :start]
end