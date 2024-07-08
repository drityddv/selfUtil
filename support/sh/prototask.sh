#!/bin/sh
protoName="*.proto"
if  [ ! -n "$1" ] ;then
    echo "proto file Name is $protoName"
else
    protoName="$1"
    echo "proto file Name is $protoName"
fi

protoc --proto_path=$PROTOBUFPATH --proto_path=./proto/ --java_out=/src/main/java/com/xiaozhang/core/net/proto/ ${protoName}

date
