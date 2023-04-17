---
title: "Projects"
date: 2022-05-30T10:35:21-05:00
draft: false
---

Here's a list of some of the open source projects I've worked on:

---

# ChocolateyManager

I was tired of manually running chocolatey updates and wanted a more automated way for my updates to just happen in the background. If you are interested in automating your software updates, have a look at the repo. 

If you run the update script from windows task scheduler you will get a nice toast message when your updater runs. 

![image](https://user-images.githubusercontent.com/15201245/211106406-ebb7d695-2f24-4c03-8e25-9e0fc3eea3e4.png)

[Repository](https://github.com/mikedhanson/ChocolateyManager)

---

# Graycord

### Why? 

Graylog does a good job as a standalone syslog server but I found a shortcoming where it wasn’t able to send alerts to discord. So, I took on the challenge to dive into python3 and learn all about docker.

### How does it work? 

The script loops on an interval doing api calls to graylog checking for the SEARCH_QUERY that you provide. For example you can specify any search query that you can make through graylog and get that data back to whatever discord CHANNEL you choose. 

[Repository](https://github.com/mikedhanson/graycord)


---

# Unraid - Rclone Backup

### How does it work? And why?

Following the 3-2-1 backup [strategy](https://www.backblaze.com/blog/the-3-2-1-backup-strategy/) and hosting an undraid server I wanted an automated way to backup core files and folders on my unraid server all while encrypting the offsite data. The solution to this was rclone. I was able to write some scripts the uses rclone to do all of this. This solution encorperates logging and alerts in unraid which get sent to a discord server. 

### Items backed up 
* Appdata 
* Flash 
* Network 
* Veeam 

| Directory      | Local                | Offsite        |
| :---           | :----:               |   ---:         |   
| Appdata        | Weekly (sun 2am)     | Weekly         |
| Libvirt        | Weekly (sun 2am)     | Weekly         |
| Flash          | Weekly (sun 2am)     | Weekly         |
| Network        |                      | Weekly         |
| Veeam          | MWF                  | Weekly         |
| Manual         | MWF                  | Weekly         |

[Repository](https://github.com/mikedhanson/graycord)


---

# Flask-Weather-Covid

### What? 

I wanted to learn flask during the pandemic.

[Repository](hhttps://github.com/mikedhanson/Flask-Weather-Covid)

---


Rclone

Thank you for taking the time to check out my projects!
