#!/bin/sh
#
# NGINX Amplify Agent install script
#
# Copyright (C) Nginx, Inc.
#

packages_url="https://packages.amplify.nginx.com"
package_name="nginx-amplify-agent"
public_key_url="https://nginx.org/keys/nginx_signing.key"
agent_conf_path="/etc/amplify-agent"
agent_conf_file="${agent_conf_path}/agent.conf"
amplify_hostname=""
api_url="https://receiver.amplify.nginx.com:443/ping/"
public_ntp="north-america.pool.ntp.org"
nginx_conf_file="/etc/nginx/nginx.conf"

#
# Functions
#

# Get OS information
get_os_name () {

    centos_flavor="centos"

    # Use lsb_release if possible
    if command -V lsb_release > /dev/null 2>&1; then
	os=`lsb_release -is | tr '[:upper:]' '[:lower:]'`
	codename=`lsb_release -cs | tr '[:upper:]' '[:lower:]'`
	release=`lsb_release -rs | sed 's/\..*$//'`

	if [ "$os" = "redhatenterpriseserver" -o "$os" = "oracleserver" ]; then
	    os="centos"
	    centos_flavor="red hat linux"
	fi
    # Otherwise it's getting a little bit more tricky
    else
	if ! ls /etc/*-release > /dev/null 2>&1; then
	    os=`uname -s | \
		tr '[:upper:]' '[:lower:]'`
	else
	    os=`cat /etc/*-release | grep '^ID=' | \
		sed 's/^ID=["]*\([a-zA-Z]*\).*$/\1/' | \
		tr '[:upper:]' '[:lower:]'`

	    if [ -z "$os" ]; then
		if grep -i "oracle linux" /etc/*-release > /dev/null 2>&1 || \
		   grep -i "red hat" /etc/*-release > /dev/null 2>&1; then
		    os="rhel"
		else
		    if grep -i "centos" /etc/*-release > /dev/null 2>&1; then
			os="centos"
		    else
			os="linux"
		    fi
		fi
	    fi
	fi

	case "$os" in
	    ubuntu)
		codename=`cat /etc/*-release | grep '^DISTRIB_CODENAME' | \
			  sed 's/^[^=]*=\([^=]*\)/\1/' | \
			  tr '[:upper:]' '[:lower:]'`
		;;
	    debian)
		codename=`cat /etc/*-release | grep '^VERSION=' | \
			  sed 's/.*(\(.*\)).*/\1/' | \
			  tr '[:upper:]' '[:lower:]'`
		;;
	    centos)
		codename=`cat /etc/*-release | grep -i 'centos.*(' | \
			  sed 's/.*(\(.*\)).*/\1/' | head -1 | \
			  tr '[:upper:]' '[:lower:]'`
		# For CentOS grab release
		release=`cat /etc/*-release | grep -i 'centos.*[0-9]' | \
			 sed 's/^[^0-9]*\([0-9][0-9]*\).*$/\1/' | head -1`
		;;
	    rhel|ol)
		codename=`cat /etc/*-release | grep -i 'red hat.*(' | \
			  sed 's/.*(\(.*\)).*/\1/' | head -1 | \
			  tr '[:upper:]' '[:lower:]'`
		# For Red Hat also grab release
		release=`cat /etc/*-release | grep -i 'red hat.*[0-9]' | \
			 sed 's/^[^0-9]*\([0-9][0-9]*\).*$/\1/' | head -1`

		if [ -z "$release" ]; then
		    release=`cat /etc/*-release | grep -i '^VERSION_ID=' | \
			     sed 's/^[^0-9]*\([0-9][0-9]*\).*$/\1/' | head -1`
		fi

		os="centos"
		centos_flavor="red hat linux"
		;;
	    amzn)
		codename="amazon-linux-ami"
		release_amzn=`cat /etc/*-release | grep -i 'amazon.*[0-9]' | \
			 sed 's/^[^0-9]*\([0-9][0-9]*\.[0-9][0-9]*\).*$/\1/' | \
			 head -1`
		release="latest"

		os="amzn"
		centos_flavor="amazon linux"
		;;
	    *)
		codename=""
		release=""
		;;
	esac
    fi
}

# Check what downloader is available
check_downloader() {
    if command -V curl > /dev/null 2>&1; then
	downloader="curl -fs"
    else
	if command -V wget > /dev/null 2>&1; then
	    downloader="wget -q -O -"
	else
	    printf "\033[31m no curl or wget found, exiting.\033[0m\n\n"
	    exit 1
	fi
    fi
}

# Add public key for package verification (Ubuntu/Debian)
add_public_key_deb() {
    printf "\033[32m ${step}. Adding public key ...\033[0m"

    check_downloader && \
    ${downloader} ${public_key_url} | \
    ${sudo_cmd} apt-key add - > /dev/null 2>&1

    if [ $? -ne 0 ]; then
	printf "\033[31m failed.\033[0m\n\n"
	exit 1
    else
	printf "\033[32m done.\033[0m\n"
    fi
}

# Add public key for package verification (CentOS/Red Hat)
add_public_key_rpm() {
    printf "\033[32m ${step}. Adding public key ...\033[0m"

    if command -V rpmkeys > /dev/null 2>&1; then
	rpm_key_cmd="rpmkeys"
    else
	rpm_key_cmd="rpm"
    fi

    check_downloader && \
    ${sudo_cmd} rm -f /tmp/nginx_signing.key.$$ && \
    ${downloader} ${public_key_url} | \
    tee /tmp/nginx_signing.key.$$ > /dev/null 2>&1 && \
    ${sudo_cmd} ${rpm_key_cmd} --import /tmp/nginx_signing.key.$$ && \
    rm -f /tmp/nginx_signing.key.$$

    if [ $? -ne 0 ]; then
	printf "\033[31m failed.\033[0m\n\n"
	exit 1
    else
	printf "\033[32m done.\033[0m\n"
    fi
}

# Add repo configuration (Ubuntu/Debian)
add_repo_deb () {
    printf "\033[32m ${step}. Adding repository ...\033[0m"

    test -d /etc/apt/sources.list.d && \
    ${sudo_cmd} test -w /etc/apt/sources.list.d && \
    ${sudo_cmd} rm -f /etc/apt/sources.list.d/amplify-agent.list && \
    ${sudo_cmd} rm -f /etc/apt/sources.list.d/nginx-amplify.list && \
    echo "deb ${packages_url}/${os}/ ${codename} amplify-agent" | \
    ${sudo_cmd} tee /etc/apt/sources.list.d/nginx-amplify.list > /dev/null 2>&1 && \
    ${sudo_cmd} chmod 644 /etc/apt/sources.list.d/nginx-amplify.list > /dev/null 2>&1

    if [ $? -eq 0 ]; then
	printf "\033[32m added.\033[0m\n"
    else
	printf "\033[31m failed.\033[0m\n\n"
	exit 1
    fi
}

# Add repo configuration (CentOS)
add_repo_rpm () {
    printf "\033[32m ${step}. Adding repository config ...\033[0m"

    test -d /etc/yum.repos.d && \
    ${sudo_cmd} test -w /etc/yum.repos.d && \
    ${sudo_cmd} rm -f /etc/yum.repos.d/nginx-amplify.repo && \
    printf "[nginx-amplify]\nname=nginx amplify repo\nbaseurl=${packages_url}/${os}/${release}/\$basearch\ngpgcheck=1\nenabled=1\n" | \
    ${sudo_cmd} tee /etc/yum.repos.d/nginx-amplify.repo > /dev/null 2>&1 && \
    ${sudo_cmd} chmod 644 /etc/yum.repos.d/nginx-amplify.repo > /dev/null 2>&1

    if [ $? -eq 0 ]; then
	printf "\033[32m added.\033[0m\n"
    else
	printf "\033[31m failed.\033[0m\n\n"
	exit 1
    fi
}

# Install package (either deb or rpm)
install_deb_or_rpm() {
    # Update repo
    printf "\033[32m ${step}. Updating repository ...\n\n\033[0m"

    test -n "$update_cmd" && \
    ${sudo_cmd} ${update_cmd}

    if [ $? -eq 0 ]; then
	printf "\033[32m\n ${step}. Updating repository ... done.\033[0m\n"
    else
	printf "\033[31m\n ${step}. Updating repository ... failed.\033[0m\n\n"
	printf "\033[32m Please check the list of supported systems here\033[0m https://git.io/vKkev\n\n"
	exit 1
    fi

    incr_step

    # Install package(s)
    printf "\033[32m ${step}. Installing package ...\033[0m\n\n"

    test -n "$package_name" && \
    test -n "$install_cmd" && \
    ${sudo_cmd} ${install_cmd} ${package_name}

    if [ $? -eq 0 ]; then
	printf "\033[32m\n ${step}. Installing package ... done.\033[0m\n"
    else
	printf "\033[31m\n ${step}. Installing package ... failed.\033[0m\n\n"
	printf "\033[32m Please check the list of supported systems here\033[0m https://git.io/vKkev\n\n"
	exit 1
    fi
}

# Detect the user for the agent to use
detect_amplify_user() {
    if [ -f "${agent_conf_file}" ]; then
	amplify_user=`grep -v '#' ${agent_conf_file} | \
		      grep -A 5 -i '\[.*nginx.*\]' | \
		      grep -i 'user.*=' | \
		      awk -F= '{print $2}' | \
		      sed 's/ //g' | \
		      head -1`

	nginx_conf_file=`grep -A 5 -i '\[.*nginx.*\]' ${agent_conf_file} | \
			 grep -i 'configfile.*=' | \
			 awk -F= '{print $2}' | \
			 sed 's/ //g' | \
			 head -1`
    fi

    if [ -f "${nginx_conf_file}" ]; then
	nginx_user=`grep 'user[[:space:]]' ${nginx_conf_file} | \
                    grep -v '[#].*user.*;' | \
                    grep -v '_user' | \
                    sed -n -e 's/.*\(user[[:space:]][[:space:]]*[^;]*\);.*/\1/p' | \
                    awk '{ print $2 }' | head -1`
    fi

    if [ -z "${amplify_user}" ]; then
	test -n "${nginx_user}" && \
	amplify_user=${nginx_user} || \
	amplify_user="nginx"
    fi
}

incr_step() {
    step=`expr $step + 1`
    if [ "${step}" -lt 10 ]; then
	step=" ${step}"
    fi
}

#
# Main
#

assume_yes=""
errors=0

for arg in "$@"; do
    case "$arg" in
    	-y)
	    assume_yes="-y"
	    ;;
	*)
	    ;;
    esac
done

step=" 1"

printf "\n --- This script will install the NGINX Amplify Agent ---\n\n"
printf "\033[32m ${step}. Checking admin user ...\033[0m"

sudo_found="no"
sudo_cmd=""

# Check if sudo is installed
if command -V sudo > /dev/null 2>&1; then
    sudo_found="yes"
    sudo_cmd="sudo "
fi

# Detect root
if [ "`id -u`" = "0" ]; then
    printf "\033[32m root, ok.\033[0m\n"
    sudo_cmd=""
else
    if [ "$sudo_found" = "yes" ]; then
	printf "\033[33m you'll need sudo rights.\033[0m\n"
    else
	printf "\033[33m not root, sudo not found, exiting.\033[0m\n"
	exit 1
    fi
fi

incr_step

# Add API key
printf "\033[32m ${step}. Checking API key ...\033[0m"

if [ -n "$AMPLIFY_API_KEY" ]; then
    api_key=$AMPLIFY_API_KEY
fi

if [ -z "$api_key" ]; then
    printf "\033[31m What's your API key? Please check the docs and the UI.\033[0m\n\n"
    exit 1
else
    printf "\033[32m using ${api_key}\033[0m\n"
fi

incr_step

# Check for Python
printf "\033[32m ${step}. Checking python version ...\033[0m"
command -V python > /dev/null 2>&1 && python_exists='yes' || python_exists='no'
command -V python2.7 > /dev/null 2>&1 && python_27='yes' || python_27='no'
command -V python2.6 > /dev/null 2>&1 && python_26='yes' || python_26='no'

if [ "$python_exists" = "no" ]; then
    printf "\033[31m python 2.6 or 2.7 is required, but could not be found.\033[0m\n\n"
    exit 1
fi

if [ "$python_27" = "no" -a "$python_26" = "no" ]; then
    printf "\033[31m python 2.6 or 2.7 is required, older or newer versions aren't supported.\033[0m\n\n"
    exit 1
fi

python_version=`python -c 'import sys; print("{0}.{1}".format(sys.version_info[0], sys.version_info[1]))'`
printf "\033[32m found python $python_version\033[0m\n"

incr_step

# Check for supported OS
printf "\033[32m ${step}. Checking OS compatibility ...\033[0m"

# Get OS name and codename
get_os_name

# Add public key, create repo config, install package
case "$os" in
    ubuntu|debian)
	printf "\033[32m ${os} detected.\033[0m\n"

	incr_step

	# Add public key
	add_public_key_deb

	incr_step

	# Add repository configuration
	add_repo_deb

	incr_step

	# Install package
	update_cmd="apt-get ${assume_yes} update"
	install_cmd="apt-get ${assume_yes} install"

	install_deb_or_rpm
	;;
    centos|amzn)
	printf "\033[32m ${centos_flavor} detected.\033[0m\n"

	incr_step

	# Add public key
	add_public_key_rpm

	incr_step

	# Add repository configuration
	add_repo_rpm

	incr_step

	# Install package
	update_cmd="yum ${assume_yes} makecache"
	install_cmd="yum ${assume_yes} install"

	install_deb_or_rpm
	;;
    *)
	if [ -n "$os" ] && [ "$os" != "linux" ]; then
	    printf "\033[31m $os is currently unsupported, apologies!\033[0m\n\n"
	else
	    printf "\033[31m failed.\033[0m\n\n"
	fi

	exit 1
esac

incr_step

# Build config file from template
printf "\033[32m ${step}. Building configuration file ...\033[0m"

if [ ! -f "${agent_conf_file}.default" ]; then
    printf "\033[31m can't find ${agent_conf_file}.default\033[0m\n\n"
    exit 1
fi

if [ -f "${agent_conf_file}" ]; then
    receiver=`cat ${agent_conf_file} | grep -i receiver | sed 's/^.*= \([^ ][^ ]*\)$/\1/'`
    ${sudo_cmd} rm -f ${agent_conf_file}.old
    ${sudo_cmd} cp -p ${agent_conf_file} ${agent_conf_file}.old
fi

if [ -n "${AMPLIFY_HOSTNAME}" ]; then
    amplify_hostname="${AMPLIFY_HOSTNAME}"
fi

${sudo_cmd} rm -f ${agent_conf_file} && \
${sudo_cmd} sh -c "sed -e 's/api_key.*$/api_key = $api_key/' \
		       -e 's/hostname.*$/hostname = $amplify_hostname/' \
	${agent_conf_file}.default > \
	${agent_conf_file}" && \
${sudo_cmd} chmod 644 ${agent_conf_file} && \
${sudo_cmd} chown nginx ${agent_conf_file} > /dev/null 2>&1

if [ $? -eq 0 ]; then
    printf "\033[32m done.\033[0m\n"
else
    printf "\033[31m failed.\033[0m\n\n"
    exit 1
fi

incr_step

# Detect the agent's euid
detect_amplify_user

test -n "${amplify_user}" && \
amplify_euid=`id -u ${amplify_user}`

if [ $? -eq 0 ]; then
    # Check is sudo can be used for tests
    printf "\033[32m ${step}. Checking if sudo -u ${amplify_user} can be used for tests ...\033[0m"

    if [ "${sudo_found}" = "yes" ]; then
	sudo_output=`sudo -u ${amplify_user} /bin/sh -c "id -un" 2>/dev/null`

	if [ "${sudo_output}" = "${amplify_user}" ]; then
	    printf "\033[32m done.\033[0m\n"
	else
	    printf "\033[31m failed. (${sudo_output} != ${amplify_user})\033[0m\n"
	    errors=`expr $errors + 1`
	fi
    else
	printf "\033[31m failed - sudo not found.\033[0m\n"
	errors=`expr $errors + 1`
    fi

    incr_step
else
    printf "\n"
    printf "\033[31m Something went wrong when detecting agent's user id, skipping some tests.\033[0m\n\n"
    errors=`expr $errors + 1`
fi

# Check agent capabilities
if [ "${errors}" -eq 0 ]; then
    # Check if the agent is able to use ps(1)
    printf "\033[32m ${step}. Checking if euid ${amplify_euid}(${amplify_user}) can find root processes ...\033[0m"

    sudo -u ${amplify_user} /bin/sh -c "ps xao user,pid,ppid,command" 2>&1 | grep "^root" >/dev/null 2>&1

    if [ $? -eq 0 ]; then
	printf "\033[32m ok.\033[0m\n"
    else
	printf "\033[31m agent won't be able to detect nginx - ps(1) is restricted!\033[0m\n"
	errors=`expr $errors + 1`
    fi

    incr_step

    printf "\033[32m ${step}. Checking if euid ${amplify_euid}(${amplify_user}) can access I/O counters ...\033[0m"

    sudo -u ${amplify_user} /bin/sh -c 'cat /proc/$$/io' >/dev/null 2>&1

    if [ $? -eq 0 ]; then
	printf "\033[32m ok.\033[0m\n"
    else
	printf "\033[31m agent won't be able to collect I/O counters for nginx - /proc/<pid>/io is restricted!\033[0m\n"
	errors=`expr $errors + 1`
    fi

    incr_step
fi

# Check nginx.conf for stub_status
if [ -f "${nginx_conf_file}" ]; then
    nginx_conf_dir=`echo ${nginx_conf_file} | sed 's/^\(.*\)\/[^/]*/\1/'`

    if [ -d "${nginx_conf_dir}" ]; then
	printf "\033[32m ${step}. Checking if stub_status is configured ...\033[0m"

	if grep -R "stub_status" ${nginx_conf_dir}/* > /dev/null 2>&1; then
	    printf "\033[32m ok.\033[0m\n"
	else
	    printf "\033[31m no stub_status in nginx config, please check\033[0m https://git.io/vKTpJ\n"
	    errors=`expr $errors + 1`
	fi

	incr_step
    fi
fi

# Test connectivity to receiver
if [ -n "${downloader}" ]; then
    printf "\033[32m ${step}. Checking connectivity to the receiver ...\033[0m"

    if ${downloader} ${api_url} | grep 'pong' >/dev/null 2>&1; then
	printf "\033[32m ok.\033[0m\n"
    else
	printf "\033[31m failed to connect to the receiver! (check\033[0m https://git.io/vKk0I)\n"
	errors=`expr $errors + 1`
    fi

    incr_step
fi

# Check system time
printf "\033[32m ${step}. Checking system time with ntpdate(8) ...\033[0m"
if command -V ntpdate > /dev/null 2>&1; then
    ntp_offset=`ntpdate -4qu ${public_ntp} 2>&1 < /dev/null | grep -i 'ntpdate.*offset' | \
		sed 's/.*offset [-]*\([.0-9][.0-9]*\) .*/\1/'`

    test -z "${ntp_offset}" && \
    ntp_offset=0

    check_offset=`python -c "print (int)(${ntp_offset} < 5)" 2>&1`

    if [ "${check_offset}" -eq 1 ]; then
	printf "\033[32m ok.\033[0m\n"
    else
	printf "\033[31m offset > 5s - please adjust the system clock for proper metric collection!\033[0m\n"
	errors=`expr $errors + 1`
    fi
else
    printf "\033[31m failed - no ntpdate installed!\033[0m\n"
    errors=`expr $errors + 1`
fi

incr_step

printf "\n"

# Finalize install
if [ "$errors" -eq 0 ]; then
    printf "\033[32m OK, everything went just fine!\033[0m\n\n"
else
    printf "\033[31m A few checks have failed - please read the warnings above!\033[0m\n\n"
fi

printf "\033[32m To start and stop the Amplify Agent type:\033[0m\n\n"
printf "     \033[7m${sudo_cmd}service amplify-agent { start | stop }\033[0m\n\n"

printf "\033[32m Amplify Agent log can be found here:\033[0m\n"
printf "     /var/log/amplify-agent/agent.log\n\n"

printf "\033[32m After the agent is launched, it might take up to 1 minute this system to appear\033[0m\n"
printf "\033[32m in the Amplify user interface.\033[0m\n\n"

printf "\033[32m PLEASE CHECK THE DOCUMENTATION HERE:\033[0m\n"
printf "     https://github.com/nginxinc/nginx-amplify-doc\n\n"

# Check for an older version of the agent running
if command -V pgrep > /dev/null 2>&1; then
    agent_pid=`pgrep amplify-agent`
else
    agent_pid=`ps aux | grep -i '[a]mplify-agent' | awk '{print $2}'`
fi

if [ -n "$agent_pid" ]; then
    printf "\033[32m Stopping old amplify-agent, pid ${agent_pid}\033[0m\n"
    ${sudo_cmd} service amplify-agent stop > /dev/null 2>&1 < /dev/null
fi

# Launch agent
printf "\033[32m Launching amplify-agent ...\033[0m\n"
${sudo_cmd} service amplify-agent start > /dev/null 2>&1 < /dev/null

if [ $? -eq 0 ]; then
    printf "\033[32m All done.\033[0m\n\n"
else
    printf "\n"
    printf "\033[31m Couldn't start the agent, please check /var/log/amplify-agent/agent.log\033[0m\n\n"
    # exit 1
fi

exit 0
