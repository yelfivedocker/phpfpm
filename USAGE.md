# Usage

## Install composer package

```bash
composer require grpc/grpc:^v1.19
```

## Generate PHP files from *.proto

```bash
protoc --php_out=. --grpc_out=.  --plugin=protoc-gen-grpc=/usr/local/bin/grpc_php_plugin test.proto
```

### options of protoc

- `--php_out` Generate php class files, and the value is the directory to store generated files.
- `--grpc_out`
- `--plugin=protoc-gen-grpc=/usr/local/bin/grpc_php_plugin` Specify php code generator.