# Solver testdata directory

Running `go test` will generate 2 files here:
- api-key.yaml: secret definition to contact APIs
- config.json: the webhook config

Don't edit these files, export `INFOMANIAK_TOKEN` & run `TEST_ZONE_NAME=example.com. make test` instead