# kakurega
It's similar to Tor2Web, where accessing a domain name on the surface web proxies and displays a specified remote HiddenService. This is a Proof of Concept (PoC), and does not guarantee secure connections between HiddenServices.

![overview](doc/overview.png)


## Requiremnets
- Docker
- Docker Compose
- Domain Name
- Backend Tor Hidden Service



## (Optional) Host Machine iptables for Cloudflare
```
chmod +x setup_firewall.sh
./setup_firewall.sh cloudflare-range.txt
```

