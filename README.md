# hello-redis
## How to use
~~~sh
docker-compose build
docker-compose up
~~~
~~~sh
bin/subscribe.sh -h redis test.message | xargs -I@ echo "message: @"
~~~
~~~sh
redis-cli -h redis PUBLISH test.message "hello"
~~~
