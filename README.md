# Kong on Cloud Foundry


## How to deploy on [Pivotal Web Services](https://run.pivotal.io)

```
cf cf create-service elephantsql turtle kong-db
cf push your-kong
```

port `8080` is used for incoming HTTP traffic from your clients. You can access this endpoint via `https://you-kong.cfapps.io`.
port `8001` is used for the Admin API. You can access this endpoint with the following command.

```
cf ssh -N -T -L 8081:localhost:8081 your-kong
```

> If you use a postgres service which is different from elephantsql, you need to change `SERVICE` in `run.sh`.


## Add your API

```
$ cf map-route your-kong cfapps.io -n example-api-kong
$ curl -is -X POST http://localhost:8001/apis -d name=example-api -d hosts=example-api-kong.cfapps.io -d upstream_url=http://httpbin.org 
HTTP/1.1 201 Created
Date: Wed, 05 Jul 2017 18:21:10 GMT
Content-Type: application/json; charset=utf-8
Transfer-Encoding: chunked
Connection: keep-alive
Access-Control-Allow-Origin: *
Server: kong/0.10.3

{"http_if_terminated":true,"id":"278a32ee-d9a9-48ac-92eb-7f39070545ea","retries":5,"preserve_host":false,"created_at":1499278870000,"upstream_connect_timeout":60000,"upstream_url":"http:\/\/httpbin.org","upstream_read_timeout":60000,"https_only":false,"upstream_send_timeout":60000,"strip_uri":true,"name":"example-api","hosts":["example-api-kong.cfapps.io"]}
```

## Forward your requests through Kong

```
curl https://example-api-kong.cfapps.io
```
