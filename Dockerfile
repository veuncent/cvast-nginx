FROM nginx:1.11.9

RUN rm -rf /usr/share/nginx/html
RUN rm /etc/nginx/conf.d/default.conf

RUN apt-get update -y &&\
	apt-get install -y dos2unix
	
ENV INSTALL_DIR=/install

# forward request and error logs to docker log collector
RUN ln -sf /dev/stdout /var/log/nginx/access.log
RUN ln -sf /dev/stderr /var/log/nginx/error.log

COPY install/localhost/fullchain.pem ${INSTALL_DIR}/fullchain.pem
COPY install/localhost/privkey.pem ${INSTALL_DIR}/privkey.pem
COPY install/nginx_base.conf ${INSTALL_DIR}/nginx_base.conf
COPY install/entrypoint.sh ${INSTALL_DIR}/entrypoint.sh
COPY install/sites-enabled ${INSTALL_DIR}/sites-enabled


RUN chmod -R 700 ${INSTALL_DIR}
RUN dos2unix ${INSTALL_DIR}/entrypoint.sh

CMD ${INSTALL_DIR}/entrypoint.sh




