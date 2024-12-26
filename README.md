# nodemcu-lua

### Usage

Create config

```
cp .env.dist .env

$EDITOR .env

make config
```

Run tests

```
make tests
```

Run linter

```
make lint
```

Upload files

```
make upload_all
```

Upload file

```
make upload FILE=config.lua
```

Clear all memory

```
nodemcu-uploader file remove_all
```

Run terminal

```
nodemcu-uploader terminal
```

Run http command

```
curl 'http://nodemcu-001/gpio?gpio=1&delay_times=995000'
```

