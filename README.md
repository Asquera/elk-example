Elasticsearch Example
---------------------

ELK stack VM with Vagrant and Puppet including the Movies100k rating dataset by Movielens.

## Setup

The VM is set up to install the following tools / frameworks.

* Elasticsearch 2.3.0 with plugin [kopf](https://github.com/lmenezes/elasticsearch-kopf)
* Logstash 2.3
* Kibana 4.5.0

Set up the box from inside the `vagrant` folder, this requires a recent Ruby. First all gems are installed, then all puppet modules and finally the box is provisioned.

The Vagrant setup also requires a few plugins, [landrush](https://github.com/vagrant-landrush/landrush) and [vbguest](https://github.com/dotless-de/vagrant-vbguest)
(only when using VirtualBox provider).

```
$ vagrant plugin install landrush
$ vagrant plugin install vagrant-vbguest  # only with Virtualbox
```

To install all gems and set up Puppet run:

```
$ bundle install
$ librarian-puppet install
$ vagrant up
```

After provisioning succeeds log into the box

```
$ vagrant ssh
```


### Kibana

Kibana is installed into the folder `/home/vagrant/kibana/kibana-4.5.0-linux`.
It should run already and is available at url `http://localhost:5601` inside the VM. To
access Kibana from the host access [http://172.17.1.22:5601](http://172.17.1.22:5601).

Install Marvel plugin in Kibana by running

```
$ bin/kibana plugin --install elasticsearch/marvel/2.3.1
```

from the Kibana src folder.


### Marvel

To install Marvel follow the steps in the [Get Started Guide](https://www.elastic.co/guide/en/marvel/current/installing-marvel.html).



## Movielens data set

There is a gem that can be used to install a data set, the [Movielens data set](http://grouplens.org/datasets/movielens/) by Grouplens that
offers data from their movie recommendation service. For more information on how to install and use this data set
check [this Readme!](dataset/movies-100k/Readme.md).