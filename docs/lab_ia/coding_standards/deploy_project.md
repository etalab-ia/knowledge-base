# Deploying your project to a server

You have developed a project, an API or a web site, and now you want to run it in a server to allow others admire your work.  Here I share how I usually do it and detail the steps needed to get this done.


## Requirements

1. You need a remote server and ssh access to it. Preferably with root or sudo access. You have to be able to use docker commands.
2. An application with all its requirements listed in a single file. For example, in a python project, a requirements.txt or similar is needed.
3. An application already running on a flask (or similar) development server, i.e., a flask, fastAPI, dash application already working in your local machine.


## Mindset

We part from the principle that you will use a server that runs multiple docker containers, each running a single application. Also, the server runs a single server-wide (non containerized) nginx reverse proxy that serves these containers to the outside world.

I focus here in the simplest case of using a Dockerfile. Using docker compose may be even easier and more straight forward, but the minimum common denominator is a Dockerfile so I will roll with this.

## Rolling Example: pandas-profiling API

To facilitate this mini-tutorial, I will take as example the API developed [here](https://github.com/giuliasantarsieri/open_ML/tree/main/profiling_api). This application is an API that receives a data.gouv.fr resource id and computes its pandas-profiling analysis using FastAPI. FastAPI is cool because it handles the Swagger documentation thingy automatically.

### Requirements

The main entry point of this app is the file `main.py`. Here I am using a docker image (from the creator of FastAPI). This image deals expects a main.py file as entry point and automatically sets sane default values for gunicorn. 

Also, there is a requirements.txt file that contain the libraries used by this app. It is important because we want to replicate as mucha as possible our local environment.


### Build and running the image
Once you have built your `Dockerfile` file and you have pushed it, you have pulled it on your server and you are ready to run it!

To build the docker image and run it we would do something like this below. Usually we want to do this in our local development machine first.
1. Build it:

    ```bash
    docker build -t pandas-profiling-api .
    ```

2. Run it:
    ```
    docker run -d -p 8080:80 -e MAX_WORKERS="2" -v /full/path/to/cache.sqlite:/app/cache.sqlite pandas-profiling-api
    ```

The flags here mean the following:
* `-d`: run the container in the background. It returns the prompt inmediatly after running this command.
* `-p`: bind the port `80` of the container to the port `8080` of your `localhost` (the server or your dev machien). It takes whatever arrives to port `8080` on the server and redirects it to the port `80` of the container. First you put the port of your host and then the port of the container!
* `-e`: indicate an environment variable to modify the behavior of the container. Here it is `MAX_WORKERS` which is used **specifically** by this container to set the number of processes started by gunicorn.
* `-v`: this allows us to mount a volume from the local disk to the be used in the container. This is super useful when you want to persist data. Here, I am mapping the database file `/full/path/to/cache.sqlite` towards the database file `/app/cache.sqlite`. The first **absolut** path is in my local machine, the second **absolut** path is found within the container.
* `pandas-profiling-api`: this is the name of the image you built before.

The `Dockerfile` is part of your github repo, so it will be available from other machines (your server). You could export your docker container to docker's hub but frankly, to me, it adds an extra layer of complexity. It may be a little bit more hassle in doing `git push` and `git pull` but it allows you to truly control what is going on. In any case, uploading your container is quite trivial also and it does has the advantage of being able to use `docker-compose` which is cool. (I am not a `docker` expert though).

### Check that it works

Given that you are on a headless server, you have no access to nice web GUIs. So you can do a `curl` to see if there is anything returning from your service:
```bash
curl localhost:8080
```
If everything goes fine, you should have an answer. I am using port `8080` because that is the port that is listening in my host (dev machine or server), as specified above. You can also send your API requests using this method ofc and check it works.


### Nginx + your app 

If all goes well, your service is ready to be reverse-proxied by nginx (or apache, here I will discuss nginx). The idea of a reverse proxy is the following:

1. Nginx is listening to requests from the internet
2. Eventually, someone goes to `yourserver.com` and nginx grabs the adress it was used (either `yourserver.com` or `yourserver.com/app` or other similar thing).
3. According to some rules, it resends the request to the corresponding service. In our case, I would like to serve my app at `yourserver.com/profiling`, so nginx would grab that request, match it with some rules (does it has a `profiling` in the adress?) and then send it to `localhost:8080`, where my API is listening (my server is sending everything it gets in `localhost:8080` to my Docker container port `80`).

Ín this way, we can have multiple docker apps running and we just need to add the corresponding rules to the nginx config each time we add a new app.

#### Nginx config 

Nginx config seems like a rabbit hole, but the gist is the following: you define `servers` for each domain you have. Each server has its own particular configuration. What really matters is that you define within each server what we call `locations`. These locations tell the server what to do when a particular URL is used (the rules of the third point above). 

Right now, as we have organized our server, and using our previous example, we do this:

We need to add a `profiling.conf` file in `/etc/nginx/sites-available/datascience/`. This config file contains exclusively the path that our API will use as URL. Note that we will always use the same domain `yourserver.com`. Let's say we want to run our app at `yourserver.com/profiler`, this is the config I would put in `profiling.conf`:
```bash
location /profiler/ {
rewrite ^/profiler(.*) $1 break;
proxy_pass http://localhost:8080;

proxy_set_header Host $host;
proxy_set_header X-Real-IP $remote_addr;
proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
}

```

Basically, I'm telling nginx to get everything that arrives at `yourserver.com/profiler/some-id-12132`, with the `rewrite` command we keep only that which inmediatly follows `/profiler` (i.e., `/some-id-12132`) and finally send it to our service running in `localhost:8080` (`localhost` means here the server itself). At the end, the query will be such as if we had sent `http://localhost:8080/some-id-12132` (again, seen from within the server itself).

Note that nginx knows that we are using `yourserver.com` as domain name because we are telling it so with another configuration file: `/etc/nginx/sites-available/datascience.studio` that looks like this:

```bash
server {
    server_name yourserver.com;
    include /etc/nginx/sites-available/datascience/*.conf;  # here we tell nginx to load all the app's configs found in this path
}
```

This last file is not supposed to be changed a lot. In general, to resolve our domain names in nginx, we create such a file in `sites-available`and create a link to `sites-enabled`, like so:

```bash
ln -s /etc/nginx/sites-available/datascience.studio /etc/nginx/sites-enabled/
``` 


The `*.config` files in `/etc/nginx/sites-available/datascience/` are the ones that need to be created, one for each new application. It will be loaded automatically with the `include` command in the previous script.




#### Nginx verification and reloading

Once you have added your config file to the correct folder, you need to make sure the config is valid and then restart nginx to take into account your modifications. Like so:

Verify configuration:
```bash
nginx -t
```
If everything is fine, restart nginx:
```
service nginx reload
```

That should be all :) 

### Security Concerns
See [here](https://cheatsheetseries.owasp.org/cheatsheets/Docker_Security_Cheat_Sheet.html) some actions that can be taken to secure our docker files.

### Common problems
1. If you add a prefix like `/profiler/` to your app, make sure your app is aware of that. That is, your app may be listengin to `localhost` but since you will be receiving your requests at `yourserver.com/profiler/` you need to specify that in your app. For example, in my Python code for the profiler app, I specify this:

    ```python
    app = FastAPI(root_path="/profiler")
    ```

    Which indicates that the root of my app is `/profiler` and not the root `/`. This is **very** important because all the resources (javascript, icons, css, images,...) of your website won't be found if the paths are not correct. You can also deal with this in your nginx config file with the magic of `rewrite`.

2. Sometimes you need to open a port with `iptables`. This is not ideal because you don't want to be opening ports.
3. You need to add the certificates info to deal with `https` instead of `http`. This can be done automatically with certbot.

### Useful commands

1. Check docker logs
    ```bash
    docker logs container_name
    ```
2. Connect to a specific runing docker container
    ```bash
    docker exec -it container_name bash
    ```
