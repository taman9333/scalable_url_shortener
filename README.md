# Scalable URL Shortner

URL shortener service implemented using [Sinatra](https://github.com/sinatra/sinatra), [MongoDB](https://www.mongodb.com/) & [etcd](https://etcd.io/).

## Installation

To run app locally you have to use [Docker Compose](https://docs.docker.com/compose/).

```bash
docker-compose up url-shortener-1 # first instance runs on Port 9292
docker-compose up url-shortener-1 # second instance runs on Port 9293
```
