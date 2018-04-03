# cvast-nginx

Customized Nginx image for Docker, to be used as reverse proxy.


Config file inspired by:  
	- [plentz' gist](https://gist.github.com/plentz/6737338)  
	- [calomel.org](https://calomel.org/nginx.html) (Option 4: Nginx reverse proxy)  
	- [Martin Gutsch's blog post](https://medium.com/@gutschilla/deploying-let-s-encrypt-in-production-13d7a4bfa546)  
  

# Contents
*   [Local and Remote proxies](#local-and-remote-proxies)
*   [Environment variables](#environment-variables)
*   [Configuration](#configuration)
*   [Mime types](#mime-types)


# Local and Remote proxies
By default, all traffic on the root path (/) is forwarded using the HTTP protocol to the location specified in the LOCAL_PROXY_HOST environment variable.  
In addition, you can (optionally) route traffic for a specific subpath (REMOTE_PROXY_SUBPATH env variable) to another destination (REMOTE_PROXY_HOST env variable). For this, the original protocol (http/https) of the request is used.  

# Environment variables
See docker-compose.yml for examples  

- NGINX_PROXY_MODE=local | local_and_remote **(Required)**.  
Specify if Nginx should act as reverse proxy for a local server or both local and remote.  
  
- LOCAL_PROXY_HOST=local-hostname  
Host name of local target server/container. Can be service name as specified in docker-compose.yml  

- LOCAL_PROXY_PORT=port  

- REMOTE_PROXY_HOST=example.com	 
Host name of remote target container.  
- REMOTE_PROXY_PORT=port  

- REMOTE_PROXY_SUBPATH=/path  
The path for which traffic needs to be redirected to the remote proxy, E.g. /database  
  

- NGINX_PROTOCOL=http | strict-https **(Required)**.  
Protocol by which this Nginx server may be addressed. When in https-only mode, all http requests are redirected as https.  

- DOMAIN_NAMES=example.com www.example.com  
Domain names by which this Nginx server can be targeted. Can be multiple, space separated domain names  

- STATIC_URL=/path  
URL from which to serve static files. If specified, static files will be served from /www/static on the Nginx container. Make sure to copy your static files to that directory, e.g. by mounting a volume on it

- MEDIA_URL=/path  
URL from which to serve media files. If specified, media files will be served from /www/media on the Nginx container. Make sure to copy your media files to that directory, e.g. by mounting a volume on it

- PUBLIC_MODE=True | False  
Specify whether search engine crawlers may index this web app. Default=False  

- TZ=EST  
Time zone, optional  


# Configuration
Main Nginx config file: /etc/nginx/nginx.conf  
Server config files: /etc/nginx/sites-enabled/  
Overwrite these or add additional config files to /etc/nginx/sites-enabled/ to customize this image.  

# Mime types
To overwrite the default allowed mime.types, mount your config file over /etc/nginx/mime.types  
