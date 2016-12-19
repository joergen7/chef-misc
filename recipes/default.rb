# coding: utf-8
#
# Cookbook Name:: chef-misc
# Recipe:: default
#
# Copyright (c) 2015 Jörgen Brandt, All Rights Reserved.

include_recipe "chef-misc::bitcoin"
include_recipe "chef-misc::erlang"
include_recipe "chef-misc::rebar3"
include_recipe "chef-misc::rebar"
include_recipe "chef-misc::lfe"
# include_recipe "chef-misc::hadoop"
