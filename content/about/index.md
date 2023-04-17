+++
title = "Hi there 👋"
draft = false
date = "2019-02-28"
aliases = ["about-me", "contact"]
author = "Michael Hanson"
ShowTitle = false
+++

```powershell
$aboutMe = [PSCustomObject]@{
    Name       = 'Michael'
    Language   = 'PowerShell'
    State      = 'South Dakota'
    OpenToWork = $true
}
return $aboutMe
```

I recently took a new position with the State of South Dakota as an Endpoint Architect with the Service Delivery team. In my free time I spend a lot of time managing and changing up my home network. Between building my own docker images to controlling IOT things around the house to self-hosting my own react portfolio, it keeps me quite busy.

I am passionate about technology and tinkering with hardware. I enjoy coffee more than I should and like to spend time outdoors either camping or on the water.

![hiking](../../static/images/hiking.png)

# The Homelab.

![homelab](homelab.png)

Eventually I'll do a writeup on my homelab but for now heres a picture and some details on what I'm running.

- Media Server: Unraid
- Switch: Juniper
- Firewall: Fortigate
- Access Points: Unifi
- Battery Backup: APC
