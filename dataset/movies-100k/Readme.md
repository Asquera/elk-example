Movielens Dataset
-----------------

This folder contains scripts and tasks to import the [movies-100k](http://grouplens.org/datasets/movielens/) dataset that contains 100.000 ratings from nearly 1.000 users for about 1.700 different movies, all part of the [Movielens.org](http://movielens.org) website.
It also allows to download and import the [movies-1M](http://grouplens.org/datasets/movielens/) dataset with 1 million ratings from 6.000 users on 4.000 movies.


The repository should be available at `/vagrant` inside the VM. Change directory and to set up the project run:

```bash
$ cd /vagrant/dataset/movies-100k
$ bundle install
```

This project folder also contains a Rakefile, to see all available rake tasks run:

```bash
$ bundle exec rake -T
```


## Dataset

Go to the data set folder and run the following commands to upload the dataset to Elasticsearch

```bash
$ cd /vagrant/dataset/movies-100k
```

First we create an Elasticsearch index to store the data set and define the mappings for all types. We use the [elasticsearch-rake-tasks gem](https://github.com/Asquera/elasticsearch-rake-tasks) and run the following command:

```bash
$ bundle exec rake es:movies:create[http://localhost:9200,movies]
```

This creates a new index named "movies" at the local Elasticsearch instance and applies the template with the same name.

Then run the rake task, for the movies 100k data set:

```bash
$ bundle exec rake create_100k_data_set
```

For the data set containing 1M ratings use

```bash
$ bundle exec rake create_1m_data_set
```

This first downloads the movies100k / 1M data set to a tmp folder, then extracts and transforms all the users, genres, movies and ratings from the data set and creates a JSON file compatible with the [Elasticsearch Bulk API](http://www.elasticsearch.org/guide/en/elasticsearch/reference/current/docs-bulk.html).

The last step is to bulk upload the generated seed file to Elasticsearch, which is done by:

```bash
$ curl -X POST 'http://localhost:9200/movies/_bulk' --data-binary @item_seed.json > /dev/null
```

This might fail for the 1M documents bulk file. Alternatively use the rake command to bulk upload which takes a bit longer:

```bash
$ bundle exec rake upload_bulk
```

This uploads all entries from the `seed.json` file to the Elasticsearch index named `movies`.
