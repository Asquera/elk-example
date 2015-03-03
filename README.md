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


## Datasets

We use the [movies-100k](http://grouplens.org/datasets/movielens/) dataset that contains 100.000 ratings from nearly 1.000 users for about 1.700 different movies, all part of the [Movielens.org](http://movielens.org) website.
