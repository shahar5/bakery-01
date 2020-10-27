#! /usr/bin/bash
#
# Checking if ncdu is already installed, if not, asking the user if he would like to install it.

pkg="ncdu"
echo -e "\n"
if rpm --query ${pkg}; then
    echo -e "\nThe package ${pkg} is already installed \n"
else
    echo -e "\nDo you want to install it?"
    select yn in "Yes" "No"; do
    case $yn in
        Yes ) 
		  echo -e "\nInstalling ${pkg}..." \
		    && sudo yum install -q -y epel-release \
		    && sudo yum install -q -y ${pkg} \
		    && echo -e "\nThe package ${pkg}has been installed \n";break;;
        No ) exit;;
    esac
	done
fi
