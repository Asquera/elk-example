Movies 100k
-----------

This folder contains scripts and tasks to import the [movies-100k](http://grouplens.org/datasets/movielens/) dataset that contains 100.000 ratings from nearly 1.000 users for about 1.700 different movies, all part of the [Movielens.org](http://movielens.org) website.


The repository should be available at `/vagrant` inside the VM. Change directory and set up the dataset.

```
$ cd /vagrant/dateset/movies100k
$ bundle install
```

This project folder also contains a Rakefile, to see all available rake tasks run:

```
$ rake -T
```


## Dataset

Go to the data set folder and run the following commands to upload the dataset to Elasticsearch

```bash
$ cd /vagrant/dataset/movies100k
```

Then run the rake task:

```
$ rake create_data_set
```

this first downloads the movies100k data set to a tmp folder, then extracts and transforms all the users, genres, movies and ratings from the data set and creates a JSON file compatible with the [Elasticsearch Bulk API](http://www.elasticsearch.org/guide/en/elasticsearch/reference/current/docs-bulk.html).

First we create an Elasticsearch index to store the data set and define the mappings for all types. We use the [elasticsearch-rake-tasks gem](https://github.com/Asquera/elasticsearch-rake-tasks) and run the following command:

```
$ rake es:movies:create[http://localhost:9200,movies]
```

This creates a new index named "movies" at the local Elasticsearch instance and applies the template with the same name.

The last step is to bulk upload the seed file to Elasticsearch, which is done by:

```
$ curl -X POST 'http://localhost:9200/movies/_bulk' --data-binary @item_seed.json > /dev/null
```

this uploads all entries from the bulk JSON file to the Elasticsearch index named `movies`.