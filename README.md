# Scalable URL Shortner

URL shortener service implemented using [Sinatra](https://github.com/sinatra/sinatra), [MongoDB](https://www.mongodb.com/) & [etcd](https://etcd.io/).

## Installation

To run app locally you have to use [Docker Compose](https://docs.docker.com/compose/).

```bash
docker-compose up url-shortener-1 # first instance runs on Port 9292
docker-compose up url-shortener-2 # second instance runs on Port 9293
```

Those commands will also run a 3-Node etcd Cluster, and MongoDB.

## Shorten a url

You can send requests to either first instance(port 9292) or second instance(port 9293) to shorten a url

``bash
curl -X POST localhost:9292/shorten -d "url=https://www.test1.com" # shorten the url using first instance
curl -X POST localhost:9293/shorten -d "url=https://www.test2.com" # shorten the url using second instance
```