# coding: utf-8
#
# Cookbook Name:: chef-misc
# Recipe:: default
#
# Copyright 2015-2017 Jörgen Brandt
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

include_recipe "chef-misc::_common"
include_recipe "chef-misc::berkeley-db"
include_recipe "chef-misc::bitcoin"
include_recipe "chef-misc::elixir"
include_recipe "chef-misc::erlang"
include_recipe "chef-misc::hadoop"
include_recipe "chef-misc::java"
include_recipe "chef-misc::lfe"
include_recipe "chef-misc::rebar"
include_recipe "chef-misc::rebar3"
