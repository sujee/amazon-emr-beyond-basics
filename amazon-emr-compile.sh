#!/bin/bash

CLASS_DIR=classes

mkdir -p $CLASS_DIR
rm -rf $CLASS_DIR/*

# compile
javac -d $CLASS_DIR -sourcepath src   -classpath $HADOOP_INSTALL/conf:$HADOOP_INSTALL/lib/*:$HADOOP_INSTALL/*:lib/*    $(find src -name "*.java")

rm -f my.jar

# extract other jars so we can bundle them together
cd $CLASS_DIR;  jar xf ../lib/opencsv-2.2.jar;  cd ..
cd $CLASS_DIR;  jar xf ../lib/mysql-connector-java-5.1.10-bin.jar;  cd ..
cd $CLASS_DIR;  jar xf ../lib/memcached-2.5.jar;  cd ..

# bundle every thing into a single jar
jar cf my.jar -C $CLASS_DIR .
