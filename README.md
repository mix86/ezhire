## README

### Deploy

```
$ docker build -t mixael/ezhire .
$ docker push mixael/ezhire
$ fleetclt stop ezhire.service && fleetclt start ezhire.service
```
