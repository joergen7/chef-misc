default.dir.archive  = "/opt/archive"
default.dir.software = "/opt/software"
default.dir.bin      = "/usr/local/bin"

# berkeley db
default.db.dir    = "#{default.dir.software}/db-4.8.30"
default.db.prefix = "#{default.db.dir}/build_unix/build"

# java
default.java.vsn  = "8"
default.java.home = "/usr/lib/jvm/java-#{default.java.vsn}-openjdk-amd64"

# hadoop
default.hd.dfs.namenode.name.dir = "/usr/local/hadoop_tmp/hdfs/namenode"
default.hd.dfs.datanode.data.dir = "/usr/local/hadoop_tmp/hdfs/datanode"
