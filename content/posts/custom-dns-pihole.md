---
title: "Custom DNS Names in PIhole"
date: "2020-04-24"
---

## Adding Custom DNS Entries into Pihole

Assuming you already have Pihole up and running, create a new .conf file in the following directory: /etc/dnsmasq.d/yourname.conf

1. nano or vim into "yourname.conf"
2. Add the following  on a new line "address=/unraid.local/192.168.1.100"
3. That IP address can be whatever IP on your LAN, for instance it could be your unraid IP. 
4. Reload pihole DNS
    1. pihole restartdns
5. Now navigate to that address you specified in step 2.
