Elasticsearch Example
---------------------

The Elasticsearch Example VM is provisioned via vagrant and puppet.
Before using the box install the following vagrant plugins.

* [landrush](https://github.com/phinze/landrush)
* [vagrant-vbguest](https://github.com/dotless-de/vagrant-vbguest) (if you are building the VM with VirtualBox)


## Setup

Set up the box from inside the `vagrant` folder, this requires a recent Ruby. First all gems are installed, then all puppet modules and finally the box is provisioned.

```
$ bundle install
$ librarian-puppet install
$ vagrant up
```

After provisioning succeeds log into the box

```
$ vagrant ssh
```



## Logstash

TODO


## Kibana

Kibana is installed into the folder `/home/vagrant/kibana/kibana-4.0.0-linux`.
It should run already and is available at url `http://localhost:5601` inside the VM. To
access Kibana from the host access [http://192.168.35.10:5601](http://192.168.35.10:5601).


