
# Docker image for Matrix

<a href="https://riot.im/app/#/room/#dockermatrix:matrix.aventer.biz" target="_new"><img src="https://img.shields.io/static/v1?label=Chat&message=Matrix&color=brightgreen"></a></span></a>
<a href="https://hub.docker.com/r/avhost/docker-matrix-riot" target="_new">![Docker Pulls](https://img.shields.io/docker/pulls/avhost/docker-matrix)</a>
<a href="https://liberapay.com/docker-matrix" target="_new"><img src="https://img.shields.io/liberapay/receives/AVENTER.svg?logo=liberapay"></a>

## Funding

[![](https://www.paypalobjects.com/en_US/i/btn/btn_donateCC_LG.gif)](https://www.paypal.com/donate/?hosted_button_id=H553XE4QJ9GJ8)

## Notice

Please make sure to use our tagged docker images and not the latest one. Specifically in a production environment you should never use :latest as that the version can be broken.

## Creating Issues and Pull request

We are working with the repository at https://github.com/AVENTER-UG/docker-matrix-riot. If you want to open issues or create pull request, please use that repository.

## Security

We verify the docker layers of our image automaticly with clair. Matrix is not a part of the vulnerabilitie scan, which  means clair will only find vulnerabilities that are part of the OS (operating system).

## Introduction

Dockerfile for installation of [riot.im] for [matrix] open federated Instant
Messaging and VoIP communication server.

## Contribution

If you want contribute to this project feel free to fork this project, do your
work in a branch and create a pull request.

To support this Dockerimage please pledge via [liberapay].

[liberapay]: https://liberapay.com/docker-matrix/

## Start

For starting you need a mapping for the `/data`-directory with
a `riot.im.conf` file and a `config.json`.

    $ docker run -d -v /tmp/data:/data avhost/docker-matrix-riot

To configure some aspect of the service, this folder can also hold
a `config.json` file. The riot-web "binary" will generated on every start of
the service then.


### Example riot.im.conf

```conf
-p 8765
-A 0.0.0.0
-c 3500
--ssl
--cert /data/fullchain.pem
--key /data/key.pem
```

### Example config.json

```json
{
    "show_labs_settings": true,  
    "room_directory": {
        "servers": ["matrix.org", "gitter.im", "libera.chat"]
    },    
    "default_server_config": {
        "m.homeserver": {
            "base_url": "https://<YOUR_MATRIX_SERVER>
        },
        "m.identity_server": {
            "base_url": "https://vector.im"
        }
    }    
}
```


## build specific arguments

* `BV_VEC`: riot.im version, optional, defaults to `master`
