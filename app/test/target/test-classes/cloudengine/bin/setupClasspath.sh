#!/bin/bash

CLASSPATH="$KERNEL_HOME"

#  Create the classpath for bootstrapping the Server from all the JARs in lib
CLASSPATH=$CLASSPATH:$KERNEL_HOME/server/*

#  Create the classpath for ORACLE the Server from all the JARs in lib
ORC_PATH=$ORACLE_HOME
if [ -d $ORC_PATH ]
then
  CLASSPATH=$CLASSPATH:$ORC_PATH/*
fi

