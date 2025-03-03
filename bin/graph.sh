#!/bin/bash

DOT_FILE=docs/mac_ip_port_service.dot
echo 'digraph mac_ip_port_service {' > $DOT_FILE
echo 'rankdir=LR;';
echo 'node [shape=box];' >> $DOT_FILE
cat docs/mac.txt | awk '{printf "\"%s\"\n", $1};' >> $DOT_FILE
echo 'node [shape=ellipse];' >> $DOT_FILE
cat docs/ip.txt | awk '{printf "\"%s\"\n", $1};' >> $DOT_FILE
echo 'node [shape=circle];' >> $DOT_FILE
cat docs/port.txt | awk '{printf "\"%s\"\n", $1};' >> $DOT_FILE
echo 'node [shape=ellipse];' >> $DOT_FILE
cat docs/service.txt | awk '{printf "\"%s\"\n", $1};' >> $DOT_FILE

cat docs/mac_ip.txt | awk '{printf "\"%s\" -> \"%s\"\n", $1, $2}' >> $DOT_FILE
cat docs/ip_port.txt | awk '{printf "\"%s\" -> \"%s\"\n", $1, $2}' >> $DOT_FILE
cat docs/port_service.txt | awk '{printf "\"%s\" -> \"%s\"\n", $1, $2}' >> $DOT_FILE

echo '}' >> $DOT_FILE