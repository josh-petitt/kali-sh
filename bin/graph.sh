#!/bin/bash

DOT_FILE=docs/mac_ip_port_service.dot
echo 'diagraph mac_ip_port_service {' > $DOT_FILE
echo 'node [shape=box];' >> $DOT_FILE
cat docs/mac.txt | awk '"{print $1}";' >> $DOT_FILE
echo 'node [shape=ellipse];' >> $DOT_FILE
cat docs/ip.txt | awk '"{print $1}";' >> $DOT_FILE
echo 'node [shape=circle];' >> $DOT_FILE
cat docs/port.txt | awk '"{print $1}";' >> $DOT_FILE
echo 'node [shape=ellipse];' >> $DOT_FILE
cat docs/service.txt | awk '"{print $1}";' >> $DOT_FILE

cat docs/mac_ip.txt | awk '"{print $1}" -> "{print $2}";' >> $DOT_FILE
cat docs/ip_port.txt | awk '"{print $1}" -> "{print $2}";' >> $DOT_FILE
cat docs/port_service.txt | awk '"{print $1}" -> "{print $2}";' >> $DOT_FILE

echo '}' > $DOT_FILE
