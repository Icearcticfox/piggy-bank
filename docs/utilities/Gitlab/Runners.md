### Add runners

```
sudo docker run -d --name gitlab-runner --restart always >      -v /srv/gitlab-runner/config:/etc/gitlab-runner >      -v /var/run/docker.sock:/var/run/docker.sock >      gitlab/gitlab-runner:latest
```
**config.toml
```concurrent = 2
check_interval = 0

[session_server]
  session_timeout = 1800

[[runners]]
  name = "docker-192-168-1-103"
  url = "https://gitlab.com/"
  token = "yours token"
  executor = "docker"
  [runners.custom_build_dir]
  [runners.cache]
    [runners.cache.s3]
    [runners.cache.gcs]
    [runners.cache.azure]
  [runners.docker]
    tls_verify = false
    image = "docker:latest"
    privileged = true
    disable_entrypoint_overwrite = false
    oom_kill_disable = false
    disable_cache = false
    volumes = ["/cache","/var/run/docker.sock:/var/run/docker.sock"]
    shm_size = 0
```
**register runner
```
docker run --rm -it -v /srv/gitlab-runner/config:/etc/gitlab-runner gitlab/gitlab-runner register
```