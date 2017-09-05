default["dir"]["archive"]  = "/opt/archive"
default["dir"]["software"] = "/opt/software"
default["dir"]["bin"]      = "/usr/local/bin"

# berkeley db
default["db"]["dir"]    = "#{default["dir"]["software"]}/db-4.8.30"
default["db"]["prefix"] = "#{default["db"]["dir"]}/build_unix/build"

# java
default["java"]["vsn"]  = "8"
default["java"]["home"] = "/usr/lib/jvm/java-#{default["java"]["vsn"]}-openjdk-amd64"

# hadoop
default["hd"]["dfs"]["namenode"]["name"]["dir"] = "/usr/local/hadoop_tmp/hdfs/namenode"
default["hd"]["dfs"]["datanode"]["data"]["dir"] = "/usr/local/hadoop_tmp/hdfs/datanode"


# erlang
default["erlang"]["vsn"] = "20.0"

# rebar3
default["rebar3"]["vsn"] = "3.4.3"

# lfe
default["lfe"]["vsn"] = "1.2.1"

# elixir
default["elixir"]["vsn"] = "1.5.1"