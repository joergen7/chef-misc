#
# Cookbook Name:: chef-misc
# Recipe:: java
#
# Copyright (c) 2016 Jörgen Brandt, All Rights Reserved.

package "openjdk-#{node["java"]["vsn"]}-jdk"
