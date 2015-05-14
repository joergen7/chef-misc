#
# Cookbook Name:: htcondor
# Recipe:: cuneiform
#
# Copyright (c) 2015 The Authors, All Rights Reserved.


archive  = node.default.dir.archive
software = node.default.dir.software
bin      = node.default.dir.bin

package "openjdk-7-jdk"

cf_link = "https://oss.sonatype.org/content/repositories/releases/de/hu-berlin/wbi/cuneiform/cuneiform-dist/2.0.0-beta/cuneiform-dist-2.0.0-beta.zip"
cf_zip = "#{archive}/#{File.basename( cf_link )}"
cf_dir = "#{software}/cuneiform-2.0.0-beta"

remote_file cf_zip do
    action :create_if_missing
    source cf_link
end

bash "extract_cuneiform" do
    code "unzip -o #{cf_zip} -d #{software}"
    not_if "#{Dir.exists?( cf_dir )}"
end

file "#{bin}/cuneiform" do
    content <<-SCRIPT
#!/usr/bin/env bash
java -cp "#{cf_dir}:#{cf_dir}/lib/*:#{cf_dir}/bin/*" de.huberlin.wbi.cuneiform.cmdline.main.Main $@
    SCRIPT
    mode "0755"
end