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


## Kibana



## Dataset

We use the [movies-100k](http://grouplens.org/datasets/movielens/) dataset that contains 100.000 ratings from nearly 1.000 users for about 1.700 different movies, all part of the [Movielens.org](http://movielens.org) website.

Go to the data set folder and run the following commands to upload to Elasticsearch

```bash
$ cd /vagrant/dataset/movies100k
$ rake create_data_set
$ rake es:movies:create[http://localhost:9200,movies]
$ curl -X POST 'http://localhost:9200/movies/_bulk' --data-binary @item_seed.json
```

This downloads the movies100k data set to a tmp folder, creates the data set suitable for Elasticsearch. Then an ES index with the template for the data set is created and last the generated bulk file with the data set is uploaded to Elasticsearch.