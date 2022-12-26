+++ 
draft = false
date = 2019-06-11T12:10:08-05:00
title = "WordPress and UnRaid"
description = "How to host a wordpress site on Unraid using Nginx"
slug = ""
authors = ["Michael Hanson"]
tags = ["Unraid", "WordPress"]
categories = []
externalLink = ""
series = []
+++

# High overview of how to setup a WordPress site that is hosted through Unraid.

This blog is something for me to look back at as a resource and to possibly help someone like you out. 

## 1\. Domain Names

Make sure you have a domain name and that you have your 'CNAME's created so DNS can propagate. Pro tip, if you can change the TTL to 1 minute to help the propagation happen quicker. Googles default is 1 hour.  (The items crossed out are dynamic dns names for my public IP)

![Capture-7](https://user-images.githubusercontent.com/15201245/144725700-f5a1dbfd-bd29-4de0-b374-32e7fe8d858e.png)


## 2\. Port Forwarding

Here is where you are going to need to configure your firewall or router for port forwarding. In my case I needed to create a new firewall policy to allow 443 and 80 to point to my Unraid server. If you have just a standard router you are going to need to forward 1443 and 180 since Unraid talks over 443 and 80 by default. 

![Capture-1](https://user-images.githubusercontent.com/15201245/144725712-a56131ea-1772-41c1-8ee9-01d7326f163c.png)


Below, I created two virtual IPs that were used in the policy in the picture above. I created 2 VIPs, one for 443 and one for port 80. 

![Capture-2](https://user-images.githubusercontent.com/15201245/144725716-3e569ddf-e9c8-4af5-a090-6a0c906969d3.png)


## 3\. Dockers

Install the following containers. 

- MariaDB 
- LetsEncrypt 
- Phpmyadmin 

Make sure the dockers are on their own custom network. They can not talk to each other if they are on the host network. 

![Capture-3](https://user-images.githubusercontent.com/15201245/144725721-775a084b-f67c-423d-8627-7fe311fc2936.png)


Now we need to create the database for our wordpress site. 

Open a terminal within unraid.

1. docker exec -it MariaDB bash
2. mysql -uroot -p
    1. The password is the default that your configured in your container when you downloaded it from CA. Don;t change your password through the maria docker.
3. Create a new DB inside MariaDB
    1. CREATE USER 'newUser' IDENTIFIED by 'password';
    2. CREATE DATABASE IF NOT EXISTS siteNameDb;
    3. GRANT ALL PRIVILEGES ON siteNameDb.\* TO 'newUser' IDENTIFIED BY 'password';
    4.  Quit
    5. Exit

## 4\. LetsEncrypt

Since we are using a FortiGate FW we can use port 80 and port 443 to talk to our reverse proxy. Below is the configuration for LE. If you have a regular router that you did your port forwarding on, you need to specify the two ports you forwarded in for http/https. 

![Capture-8](https://user-images.githubusercontent.com/15201245/144725724-e2132440-ed1f-40a6-acc3-ff26d424d8fc.png)


## 5\. Ngnix

Navigate to the default config

Located on your server here - \\unraidServerappdataletsencryptngnixsite-configdefault

You can view my config here - [LINK](https://pastebin.com/AWNxYWMT)

## 6\. WordPress

1. Download the latest version of wordpress. You can find it here. -> [wordpress.org/download](https://wordpress.org/download/) 
2. Extract and mode the contents under your www folder under LetsEncrypt
    1. \\unraidServerappdataletsencryptngnixwwwdomain
3. From here you can navigate to your domain name in your favorite browser and fill out the WP setup

![Capture-8](https://user-images.githubusercontent.com/15201245/144725728-f9951848-60e0-4480-aa18-3570a2702ff3.png)


1. 1. Database name: configured in step 2a
    2. Username: configured in step 2a
    3. Password: configured in step 2a
    4. Database host: this is the MariaDB docker IP and port.
    5. Table Prefix: “wp\_”

## 7\. Other Settings for WordPress

1. 1.    Migrating wp from hosting provider to unraid
        
        1. Backup your current WordPress site using the plugin “all in one wp migration” this creates a database backup as well as all content on the site. Stored in one file
            
        2. Once we get a backup made, we can move over to our new site and install the plugin “all in one wp migration”
            
        3. Navigate to the import area under the plugin and navigate to your backup.wpress file that you took in the first step. If you get an error regarding upload size, see step 6b.
            
    2. Changing upload size for restoring wp site
        
        1. Install the plugin called “all-in-one-wp-migration-file-extension.zip” found here [https://import.wp-migration.com/all-in-one-wp-migration-file-extension.zip](https://import.wp-migration.com/all-in-one-wp-migration-file-extension.zip)
            

## HINTS

1. When you initially configure your WP site you might try and delete some plugins and run into the FTP popup. Add the following to wp-config.php:
    1. `define( 'FS_METHOD', 'direct' );`

## Shout-Outs

HUGE thank you to the following for helping me learn about self hosting and reverse proxies. 

- [SpaceInvader One](https://www.youtube.com/channel/UCZDfnUn74N0WeAPvMqTOrtA)
- [Technicalramblings](https://technicalramblings.com/) - [source](https://technicalramblings.com/blog/how-to-set-up-a-wordpress-site-with-letsencrypt-and-mariadb-on-unraid/) 
- IceMan