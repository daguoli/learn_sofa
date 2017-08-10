#!/bin/bash

SCRIPT="$0"

#determine home
while [ -h "$SCRIPT" ] ; do
  ls=`ls -ld "$SCRIPT"`
  # Drop everything prior to ->
  link=`expr "$ls" : '.*-> \(.*\)$'`
  if expr "$link" : '/.*' > /dev/null; then
    SCRIPT="$link"
  else
    SCRIPT=`dirname "$SCRIPT"`/"$link"
  fi
done

# determine kernel home
KERNEL_HOME=`dirname "$SCRIPT"`/..

# make KERNEL_HOME absolute
KERNEL_HOME=`cd $KERNEL_HOME; pwd`

LAUNCHER_PROFILE=$KERNEL_HOME/server/profile.core.properties
PLUGINS_DIR=$KERNEL_HOME/plugins

# make sure we have JAVA_HOME set
if [ -z "$JAVA_HOME" ]
then
    echo The JAVA_HOME environment variable is not defined
    exit 1
fi

#  decide LAUNCHER_JAR
for file in $KERNEL_HOME/server/*.jar
do
      if [[ $file == *ce-kernel-launcher-*.jar ]]
      then
      LAUNCHER_JAR=$file
      fi
done

"$JAVA_HOME/bin/java" -classpath "$LAUNCHER_JAR" com.alipay.cloudengine.launcher.ServerInfo $LAUNCHER_PROFILE $PLUGINS_DIR
