#!/bin/bash

#=================================================================
#   文件名称：nodejs.sh
#   创 建 者：tanliqing tanliqing2010@163.com
#   创建日期：2017年11月28日
#   描    述：
#
#================================================================*/

function nodejs_install(){
    case $distro in
    centos)
    pkgs="nodejs npm" 
    install_deps "${pkgs}"
    print_info $? "install_nodejs"
    ;;
    debian)
    apt-get install wget -y
    apt-get install sudo -y
    
    if [ "${ci_http_addr}"x = "http://172.19.20.15:8083"x ];then
           [ ! -f node-v8.15.0-linux-arm64.tar.gz ] && wget -c ${ci_http_addr}/test_dependents/node-v8.15.0-linux-arm64.tar.gz
           [ ! -d node-v8.15.0-linux-arm64 ] && tar -zxf node-v8.15.0-linux-arm64.tar.gz
	   cd node-v8.15.0-linux-arm64/bin
	   ln -s $(pwd)/node /usr/bin/node
           current_dir=`pwd`
           export PATH=$PATH:$current_dir
	   cd -
	   node -v
	   npm -v
	   print_info $? "install_nodejs"
	
    else
    
    wget -qO- ${ci_http_addr}/test_dependents/setup_8_http.x | sudo -E bash -
    apt-get install -y nodejs
    print_info $? "install_nodejs"
    fi
    ;;
   esac
}

function nodejs_npm(){

    npm install "express"
    print_info $? "nodejs_install_package_local"
   
    if [ -d ./node_modules/express/  ];then
        true
    else
        false
    fi
    print_info $? "nodejs_list_local_package_at_current_dir"

    npm install "express" -g
    print_info $? "nodejs_install_package_global"
    
    npm list  -g | grep express 
    print_info $? "nodejs_list_global_package_at_/usr/lib/node_modules/"
    
    
    npm uninstall express
    if [ -d ./node_modules/express  ];then
        false
    else
        true
    fi
    print_info $? "nodejs_uninstall_local_package"

    npm uninstall express -g
    npm list express -g
    if [ $? -eq 1 ];then
        true
    else
        false
    fi
    print_info $? "nodejs_uninstall_global_package"

}

function nodejs_fs_test(){

    npm install 'child_process' -g
    print_info $? "nodejs_install_'child_process'_package"
    node readFile.js
}

function nodejs_uninstall(){
   case $distro in
     centos)
     pkgs="nodejs"
     remove_deps "${pkgs}" 
     print_info $? "uninstall_nodejs"
     ;;
    
     debian)
     if [ "${ci_http_addr}"x = "http://172.19.20.15:8083"x ];then
         rm -f /usr/bin/node
         rm -rf node-v8.15.0-linux-arm64
 	 echo ${path#/$current_dir:}
         print_info $? "uninstall_nodejs"
     else
    
         pkgs="nodejs"
         remove_deps "${pkgs}" 
         print_info $? "uninstall_nodejs"
     fi
     ;;
   esac

}

