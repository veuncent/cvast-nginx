#!/bin/bash

set -- ${DOMAIN_NAMES}
PRIMARY_DOMAIN_NAME=$1
LETSENCRYPT_BASEDIR="${LETSENCRYPT_BASEDIR:-/etc/letsencrypt}"
LETSENCRYPT_LIVEDIR=${LETSENCRYPT_BASEDIR}/live
LETSENCRYPT_LOCALHOST_DIR=${LETSENCRYPT_LIVEDIR}/localhost
LETSENCRYPT_DOMAIN_DIR=${LETSENCRYPT_LIVEDIR}/${PRIMARY_DOMAIN_NAME}
NGINX_BASEDIR="/etc/nginx/"
NGINX_CONF="/etc/nginx/nginx.conf"
SITES_ENABLED_DIR="/etc/nginx/sites-enabled"
WEB_ROOT="${WEB_ROOT:-/var/www}"
FULLCHAIN_FILENAME=fullchain.pem
PRIVATE_KEY_FILENAME=privkey.pem

wait_for_certificate() {
	while true; do
		if [[ ! -d ${LETSENCRYPT_DOMAIN_DIR} ]]; then
			echo "Waiting for certificate for ${PRIMARY_DOMAIN_NAME} to download..."
			sleep 5
		else
			break
		fi
	done
}

start_nginx_background() {
    echo "Temporarilly starting NginX in order to let the certificate service verify something is running on port 80..."
	service nginx start
}

stop_nginx_background() {
    echo "Stopping Nginx in order to reload config and run it in the foreground..."
	service nginx stop
}

start_nginx_foreground() {
	echo "Running Nginx on ${DOMAIN_NAME} in the foreground"
	exec nginx -g 'daemon off;'
}

set_search_engine_settings() {
	if [[ ${PUBLIC_MODE} == True ]]; then
		allow_text="" 
		replace_values_in_dir ${SITES_ENABLED_DIR} "<allow_or_disallow>" "${allow_text}"
	else 
		disallow_text=" /" 
		replace_values_in_dir ${SITES_ENABLED_DIR} "<allow_or_disallow>" "${disallow_text}"
	fi
}

set_strict_https_nginx_conf() {
	cp ${INSTALL_DIR}/nginx_strict_https.conf ${NGINX_CONF}
	cp -r ${INSTALL_DIR}/sites-enabled ${NGINX_BASEDIR}
	echo "Initializing NginX to run on: ${DOMAIN_NAMES}"
	echo "... and serve as reverse proxy for Docker container: ${PROXY_CONTAINER}..."
	replace_values_in_dir ${SITES_ENABLED_DIR} "<proxy_container>" "${PROXY_CONTAINER}"	
	replace_values_in_dir ${SITES_ENABLED_DIR} "<proxy_port>" "${PROXY_PORT}"	
	replace_values_in_dir ${SITES_ENABLED_DIR} "<domain_names>" "${DOMAIN_NAMES}"	
	replace_values_in_dir ${SITES_ENABLED_DIR} "<primary_domain_name>" "${PRIMARY_DOMAIN_NAME}"	
}

set_nginx_certificate_paths() {
	echo "Setting NginX conf to use certificates in ${LETSENCRYPT_DOMAIN_DIR}..."
	replace_values_in_dir ${SITES_ENABLED_DIR} "${LETSENCRYPT_LOCALHOST_DIR}" "${LETSENCRYPT_DOMAIN_DIR}"	
}

copy_localhost_certificates() {
	mkdir -p ${LETSENCRYPT_LOCALHOST_DIR}
	if [[ ! -f ${LETSENCRYPT_LOCALHOST_DIR}/${FULLCHAIN_FILENAME} ]]; then
		cp ${INSTALL_DIR}/${FULLCHAIN_FILENAME} ${LETSENCRYPT_LOCALHOST_DIR}
	fi
	if [[ ! -f ${LETSENCRYPT_LOCALHOST_DIR}/${PRIVATE_KEY_FILENAME} ]]; then
		cp ${INSTALL_DIR}/${PRIVATE_KEY_FILENAME} ${LETSENCRYPT_LOCALHOST_DIR}
	fi	
}

check_variable() {
	local VARIABLE_VALUE=$1
	local VARIABLE_NAME=$2
	if [[ -z ${VARIABLE_VALUE} ]] || [[ "${VARIABLE_VALUE}" == "" ]]; then
		echo "ERROR! Environment variable ${VARIABLE_NAME} not specified. Exiting..."
		exit 1
	fi 
}

replace_values_in_dir() {
	local DIRECTORY=$1
	local ORIGINAL_VALUE=$2
	local NEW_VALUE=$3
	find ${DIRECTORY} -type f -exec sed -i "s#${ORIGINAL_VALUE}#${NEW_VALUE}#g" {} \;
}


#### Starting point
# For LetsEncrypt acme challange
mkdir -p ${WEB_ROOT}

check_variable "${DOMAIN_NAMES}" DOMAIN_NAMES
check_variable "${PROXY_CONTAINER}" PROXY_CONTAINER
check_variable "${PROXY_PORT}" PROXY_PORT

set_strict_https_nginx_conf
copy_localhost_certificates

# This is in case you forget to close ports 80/443 on a test/demo environment: 
# Environment variable PUBLIC_MODE needs to be explicitly set to True if search enginges should index this website
set_search_engine_settings

if [[ "${PRIMARY_DOMAIN_NAME}" != "localhost" ]] && [[ ! -d ${LETSENCRYPT_DOMAIN_DIR} ]]; then
	start_nginx_background
	wait_for_certificate
	stop_nginx_background
fi

set_nginx_certificate_paths
start_nginx_foreground