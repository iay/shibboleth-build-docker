#!/bin/bash

maven_dir=`echo /opt/apache-maven-*`
export M2_HOME=${maven_dir}
export M2=${M2_HOME}/bin
export PATH=${M2}:${PATH}
