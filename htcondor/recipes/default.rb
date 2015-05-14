#
# Cookbook Name:: htcondor
# Recipe:: default
#
# Copyright (c) 2015 The Authors, All Rights Reserved.

include_recipe "htcondor::common"
include_recipe "htcondor::htcondor"
include_recipe "htcondor::cuneiform"