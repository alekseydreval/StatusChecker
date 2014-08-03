# StatusChecker
The problem it is supposed to solve: https://gist.github.com/dozenthoughts/9d99659c165fea89027b
This service allows to check if a website is available. Availability statistcis are represented in graph.

## Cofigure and launch

* `bundle install`
* `ruby status_checker.rb`


## API description
The following API endpoints are exposed:

| Endpoint        | Description |
| -------------   |:-------------:|
|`/send?url=<url>`|check <url> for availability|
|`/stats`         |display statistics graph (default: for the last 10 seconds)|

## Running tests
* `cd StatusChecker`
* `rspec`

## Benchmark

Using one fork on my machine yielded the following results:

| ab -n 10000 http://0.0.0.0:3000/ |   Requests per second:    5985.64 [#/sec] (mean) |
                                       Time per request:       0.167 [ms] (mean)      |

| ab -n 10000 'http://0.0.0.0:3000/send?url=http://ya.ru' |  Requests per second:    746.60 [#/sec] (mean) |
                                                             Time per request:       1.339 [ms] (mean)     |

| ab -n 10000 'http://0.0.0.0:3000/stats' |  Requests per second:    3679.65 [#/sec] (mean) |
                                             Time per request:       0.272 [ms] (mean)      |
