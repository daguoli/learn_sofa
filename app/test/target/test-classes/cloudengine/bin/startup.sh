#!/bin/bash

SCRIPT="$0"
DEPLOY_DIR=$1
WORK_DIR=$2
JAVA_OPTS_PARAM=$3

# 兼容，使用第三个参数传入JAVA_OPTS
if [ -z "$JAVA_OPTS" ]; then
    if [ -n "$JAVA_OPTS_PARAM" ]; then
        JAVA_OPTS=$JAVA_OPTS_PARAM
    fi
fi


# 确定HOME目录
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

#等待启动完成
wait_for_ready_bak()
{
    exptime=0
    count=0
    while true
    do 
      ret=`fgrep '部署完成' $FILE_STDOUT_LOG`
      if [ -z "$ret" ]; then
        sleep 1
        ((exptime++))
        echo -n -e "\rWait CloudEngine Start: $exptime..."
      else
        echo "CloudEngine Start Done."
        return
      fi
      
      failed=`fgrep 'CloudEngine start failed' $FILE_STDOUT_LOG`
      if [ ! -z "$failed" ]; then
        echo "CloudEngine Start Failed"
        return
      fi
    done
}

#等待启动完成
wait_for_ready()
{
    app_num=0
    mark='ce'
    while true
    do
      if [ z$mark = z"ce" ]; then
        total=`grep '需要部署的系统个数为' $FILE_STDOUT_LOG | awk -F: '{print $2}'`
        #total="1"
        if [ z"$total" != "z" ]; then
                mark='app'
                echo -e "\ncloudegine开始部署$total个应用"
                #app_num=1
                sleep 2
                echo -n "."
                continue
                #return
        else 
                sleep 2
                echo -n "."
        fi
      elif [ z$mark = z"app" ]; then
        s_num=`grep -Ec '^部署完成.*系统$' $FILE_STDOUT_LOG`
        f_num=`grep -Ec '^部署失败.*系统$' $FILE_STDOUT_LOG`
        if [ $f_num -gt 0 ];then
                echo -e "\n有$app_num个应用部署失败，退出!"
                #return
                break
        fi
        if [ $s_num -gt $app_num ]; then
                echo -e "\n已完成$s_num个应用的部署"
                app_num=$s_num
                sleep 2
                echo -n "."
                continue
        fi
        if [ $s_num -eq $total ]; then
                echo -e "\n整个部署过程已完成"
                #return
                break
        fi
                sleep 2
                echo -n "."
      fi
    done
}


# determine kernel home
KERNEL_HOME=`dirname "$SCRIPT"`/..

# make KERNEL_HOME absolute
KERNEL_HOME=`cd $KERNEL_HOME; pwd`

#设置环境变量
CATALINA_HOME=$KERNEL_HOME
export CATALINA_HOME


# setup classpath and java environment
. $KERNEL_HOME/bin/setupClasspath.sh

#设置日志目录
log_prop=`cat $KERNEL_HOME/config/kernel.properties | grep "loggingRoot"`
log_value=${log_prop#*=}
DIR_LOG=$HOME/logs
if [ ${#log_value} -gt 1 ]
then
    DIR_LOG=`echo $log_value | tr -d "\r"`
fi

#设置服务器profile
profile_prop=`cat $KERNEL_HOME/config/kernel.properties | grep "server.profile.mode"`
profile_value=${profile_prop#*=}
LAUNCHER_MODE=$KERNEL_HOME/server/profile.core.properties
if [ $profile_value == "web" ]
then
	LAUNCHER_MODE=$KERNEL_HOME/server/profile.web.properties
fi

#JAVA_OPTS="-server -Xms1800m -Xmx1800m -Xmn680m -Xss256k -XX:PermSize=300m -XX:MaxPermSize=300m -XX:+UseConcMarkSweepGC -XX:+UseParNewGC -XX:CMSFullGCsBeforeCompaction=5 -XX:+UseCMSCompactAtFullCollection -XX:+CMSClassUnloadingEnabled -XX:+DisableExplicitGC -verbose:gc -XX:+PrintGCDetails -XX:+PrintGCTimeStamps -Dcom.sun.management.jmxremote.port=9981 -Dcom.sun.management.jmxremote.ssl=false -Dcom.sun.management.jmxremote.authenticate=false"

#DEBUG_OPTS="-Xdebug -Xrunjdwp:transport=dt_socket,address=8000,server=y,suspend=n"

#exec
mkdir -p $DIR_LOG
cd $DIR_LOG

CONFIG_DIR=$KERNEL_HOME/config

KERNEL_JAVA_PARMS=""$JAVA_OPTS" \
 -Dlog4j.ignoreTCL="true" \
 -Duser.home=$HOME \
 -Duser.dir="$DIR_LOG" \
 -Dcom.alipay.cloudengine.kernel.home="$KERNEL_HOME" \
 "$DEBUG_OPTS" \
 -classpath "$CLASSPATH" \
 com.alipay.cloudengine.launcher.CELauncher \
 -config "$LAUNCHER_MODE" \
 -Fcom.alipay.cloudengine.kernel.home="$KERNEL_HOME" \
 -Fcom.alipay.cloudengine.kernel.config="$CONFIG_DIR" \
 -Fcloudengine.deploy.dir="$DEPLOY_DIR" \
 -Fcloudengine.work.dir="$WORK_DIR" \
 -Forg.eclipse.gemini.web.tomcat.config.path="$KERNEL_HOME/config/tomcat-config-server.xml" \
 -Fosgi.configuration.area="$WORK_DIR/osgi/configuration""

#启动容器
"$JAVA_HOME/bin/java" $KERNEL_JAVA_PARMS 

#echo $! > $WORK_AREA/.pid
#wait_for_ready

