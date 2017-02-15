# cvast-nginx

Customized Nginx instance for Docker, to be used as reverse proxy.

Developed by the Center for Virtualization and Applied Spatial Technologies (CVAST),
University of South Florida

Config file inspired by: 
	- https://gist.github.com/plentz/6737338 
	- https://calomel.org/nginx.html Option 4: Nginx reverse proxy
	- https://medium.com/@gutschilla/deploying-let-s-encrypt-in-production-13d7a4bfa546
	
	
	
### Mime types
To overwrite the default allowed mime.types, mount a config file over /etc/nginx/mime.types