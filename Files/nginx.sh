#! /usr/bin/bash
#
# Checking if Nginx is already installed, if not, it'll install it. Also has an option to uninstall cleanly.

pkg=nginx
echo "Nginx"
    select yn in "Check-and-Install" "Delete"; do
    case $yn in
        Check-and-Install ) 
		  rpm --query ${pkg}
		if [ $? -eq 0 ]; then
			echo "${pkg} is already installed"
		else
			echo -e "Installing ${pkg}...\n" \
		    && sudo yum install -q -y epel-release ${pkg} \
            && sudo yum install -q -y ${pkg} \
		    && sudo systemctl start --quiet ${pkg} \
		    && sudo systemctl enable --quiet ${pkg} \
            && sudo systemctl is-active --quiet ${pkg}
			if [ $? -eq 0 ]; then
				echo -e "\n"${pkg} "service is up and running!\n"
			else
				echo "There was an error running" ${pkg}
			fi
		fi;break;;
        Delete ) 
		  echo -e "Uninstalling ${pkg}...\n" \
		    && sudo systemctl stop nginx.service \
		    && sudo systemctl disable nginx.service \
		    && sudo rm -rf /etc/nginx \
		    && sudo rm -rf /var/log/nginx \
		    && sudo rm -rf /var/cache/nginx/ \
		    && sudo rm -rf /usr/lib/systemd/system/nginx.service \
		    && sudo yum remove -y -q ${pkg} \
		    && echo -e "\n${pkg} has been removed\n";exit;;
    esac
	done
