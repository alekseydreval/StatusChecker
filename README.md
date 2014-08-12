# StatusChecker

This service allows to check if a website is available. Availability statistcis are represented in graph.

Сервис пересылки запросов
 
Технологии
- ruby
- rspec
- EventMachinne
 
Нужно разработать сервис, который занимается гарантированной доставкой http get запросов на основе Event Machine. 
 
- Сервис имеет апи /send?url=<url>, где url это http запрос который нужно доставить
- На все запросы api сразу отвечает 200 c телом OK 
- После этого сервис пытается доставить все запросы, если при выполнении url получен ответ 200, то запрос считается доставленным. Если не получилось - пробуем снова позже
- У сервиса есть раздел /stats, там показывается график на highcharts с тремя линиями - полученные запросы, успешные запросы, неуспешные запросы. Разрешение 1 секунда. 
- Код должен быть покрыт тестами
- Должен прилагаться скрипт для нагрузочного тестирования (ab или аналогичная утилита)
- Допустимо если сервис не будет persistent, те будет терять данные при рестарте


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
