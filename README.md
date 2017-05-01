# cvast-nginx

Customized Nginx instance for Docker, to be used as reverse proxy.

Developed by the Center for Virtualization and Applied Spatial Technologies (CVAST),
University of South Florida  

Config file inspired by:  
	- https://gist.github.com/plentz/6737338  
	- https://calomel.org/nginx.html Option 4: Nginx reverse proxy  
	- https://medium.com/@gutschilla/deploying-let-s-encrypt-in-production-13d7a4bfa546  
	
## Environment variables
See docker-compose.yml for examples  
	- LOCAL_PROXY_HOST=<host name of local proxy container>   (Can be service title as specified in docker-compose.yml)  
	- LOCAL_PROXY_PORT=8000  
	- REMOTE_PROXY_HOST=<host name of remote proxy container>   (Can be service title as specified in docker-compose.yml)  
	- REMOTE_PROXY_PORT=8000  
	- DOMAIN_NAMES=example.com www.example.com  
	- PUBLIC_MODE=False    (Specified whether search engine crawlers may index this web app. Default=False)  
	- TZ=EST  (Time zone, optional)


## Configuration
Main Nginx config file: /etc/nginx/nginx.conf  
Server config files: /etc/nginx/sites-enabled/  
Overwrite these or add additional config files to /etc/nginx/sites-enabled/ to customize this image.  

## Mime types
To overwrite the default allowed mime.types, mount your config file over /etc/nginx/mime.types
