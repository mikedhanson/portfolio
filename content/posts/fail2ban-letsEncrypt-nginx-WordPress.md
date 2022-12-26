+++ 
draft = false
date = 2019-12-27T11:50:31-05:00
title = "Setting up fail2ban with LE/NGINX/WP"
description = "Enable fail2ban to harden your wordpress site behind Nginx"
slug = ""
authors = ["Michael Hanson"]
tags = ["Nginx", "LetsEncrypt", "WordPress"]
categories = []
externalLink = ""
series = []
+++

## NOTICE:

This tutorial is assuming that you are using the Swag docker container through UnRaid. If you are, then lets proceed.

## 1\. Edit jail.local

At the bottom of the file, add the following block of code.

`[wordpress]  
enabled = true  
port = http,https  
filter = wordpress-auth  
logpath = /config/log/nginx/access.log  
maxretry = 3  
bantime = 3600  
ignoreip = 192.168.1.0/24  
`

## 2\. Edit filters

Inside the filter.d directory create a new config file called "wordpress-auth.conf"

Within that file add the following code:

`  
[Definition]`

`failregex = .*POST.*(wp-login.php|xmlrpc.php).* (403|200)  
`

You might have noticed that I added 403 reponse code to the regex expression. By default a failed authentication to /wp-admin returns a 200, however, I set up a custom return code for failed authentication to return a 403. 

Inside the "wwwrootwp-contentmu-plugins" directory, I created a file called login\_helper.php with the following code.

`  
/* Return 403 instead of 200 when wp-login failed */`

`add_action( 'wp_login_failed', function () {  
     status_header(403);  
} );  
`

![](images/Capture-2.png)

## 3\. Reload Swag Docker

You should now be seeing content within the log files under Swag/log

![](images/Capture-3.png)

Here you can see a list of IPs that tried to hit /wp-admin on my site but were unable to. Click [here](https://michaelhanson.dev/blocking-wp-admin-using-nginx/) to see how to block all public IPs using Nginx. 

![](images/Capture-4-1024x260.png)