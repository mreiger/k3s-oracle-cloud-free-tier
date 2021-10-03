# k3s-oracle-cloud-free-tier
Create a k3s cluster on Oracle Cloud's free for life tier.

This is part of the Medium article:
https://chris-graham.medium.com/create-a-free-k3s-cluster-in-oracle-cloud-using-the-always-free-tier-7c4bc50072cc

## TODO

* [x] fix iptables so metrics etc work
    * [x] Set in cloud-init does not survive reboot - make it permanent
* [ ] Fix nginx-controller
    * [ ] resource requests so HPA can work
    * [x] Make sure that the controller pod(s) do(es) not start on server
* [ ] Make the kubernetes / helm part behave - different tf module needed maybe?
* [x] Try out loadbalancer
* [ ] Try out trafik instead of nginx as ingress
* [ ] Figure out arm workers!
* [ ] Long goal - longhorn?
