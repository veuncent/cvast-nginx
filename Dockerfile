FROM nginx:1.11.9

RUN rm -rf /usr/share/nginx/html
RUN rm /etc/nginx/conf.d/default.conf

RUN apt-get update -y &&\
	apt-get install -y dos2unix
	
ENV INSTALL_DIR=/install

COPY install/localhost/fullchain.pem ${INSTALL_DIR}/fullchain.pem
COPY install/localhost/privkey.pem ${INSTALL_DIR}/privkey.pem
COPY install/nginx_strict_https.conf ${INSTALL_DIR}/nginx_strict_https.conf
COPY install/entrypoint.sh ${INSTALL_DIR}/entrypoint.sh
COPY install/sites-enabled ${INSTALL_DIR}/sites-enabled


RUN chmod -R 700 ${INSTALL_DIR}
RUN dos2unix ${INSTALL_DIR}/entrypoint.sh

CMD ${INSTALL_DIR}/entrypoint.sh




