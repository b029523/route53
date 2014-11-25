#
# Cookbook Name:: route53
# Recipe:: default
#
# Copyright 2011, Heavy Water Software Inc.
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
#

if platform_family?('rhel') && major_version < 6
  include_recipe 'yum::epel'
  pkgs = ["libxml2-devel", "libxslt1-devel"]
else
  pkgs = value_for_platform_family(
                  "debian" => ["libxml2-dev","libxslt1-dev"],
                  "rhel" => ["libxml2-devel","libxslt1-devel"],
                  "default" => ["libxml2-dev","libxslt1-dev"]
                )
end

pkgs.each do |pkg|
  package pkg do
    action :install
  end
end


chef_gem "fog" do
  version "1.12.1"
  action :install
end
