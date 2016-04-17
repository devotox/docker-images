# platform Docker Edition

### References
	1. [Why Docker](http://www.ybrikman.com/writing/2015/05/19/docker-osx-dev/)
	2. [Docker Best Practices](http://crosbymichael.com/dockerfile-best-practices.html)
	3. [Docker Compoose](https://docs.docker.com/compose/compose-file/)
	4. [Dockerfile](https://docs.docker.com/engine/reference/builder/)
	5. [Docker Machine](https://docs.docker.com/machine/reference/)
	6. [Docker AWS Config](http://docs.aws.amazon.com/elasticbeanstalk/latest/dg/create_deploy_docker_v2config.html)
	7. [Consul Service Discovery](http://thesecretlivesofdata.com/raft/)

### Helper Shell Scripts
	* All scripts are idempotent, meaning no matter how many times you run it it will leave you in the correct state and start from its last checkpoint if any errors
	* `sh docker/install` - Does the full install you need of docker and its dependencies
	* `sh docker/setup` - Setup your docker environment using platform-dev
	* `sh docker/rebuild` - Deletes your environment and rebuilds it from scratch
	* `sh docker/start` - Starts Docker environment and sets it ready to use
	* `sh docker/stop` - Stops Docker environment, cleans it, stop Docker machine
	* `sh docker/uninstall` - Removes docker and all its dependencies
	* `sh docker/clean` - Cleans Docker environment

### Setup
	* Install docker-osx-dev environment - `sh docker/install && sh docker/setup`
	* OR MANUALLY
	* Install Homebrew - `ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"`
	* Make sure Homebrew is up to date - `brew uninstall --force brew-cask; brew update`
	* Install virtualbox - `brew cask install virtualbox`
	* Install docker - `brew cask install dockertoolbox`
	* Install fswatch - `brew install fswatch`
	* Install coreutils - `brew install coreutils`
	* Setup Environment - `run commands in docker/setup`

### Extras ( unneeded )
	* Install consul - `brew cask install consul`
	* Install python/pip - `brew install python`
	* Install ansible - `pip install ansible`
	* Install ruby - `brew install ruby`
	* Install Parallels Driver - `brew install docker-machine-parallels`
	* Install vagrant - `brew cask install vagrant`
	* Install vagrant manager - `brew cask install vagrant-manager`
	* Install vagrant plugins
		* `vagrant plugin install vagrant-cachier`
		* `vagrant plugin install vagrant-parallels`
		* `vagrant plugin install vagrant-gatling-rsync`
		* `vagrant plugin install vagrant-docker-compose`

### Start Up
	* `sh docker/start`
	* `docker-machine create --driver "virtualbox" --virtualbox-cpu-count 2 --virtualbox-memory 4096 platform-dev --virtualbox-disk-size 102400` - create virtual machine (virtualbox)
	* OR
	* `docker-machine create --driver "parallels" --parallels-cpu-count=2 --parallels-memory=4096 --parallels-disk-size 102400 platform-dev-parallels` - create virtual machine (parallels)
	* THEN
	* `eval (docker-machine env platform-dev)` - Attach terminal to docker machine
	* `docker-osx-dev` - Run for OSX Development Performance
	* `docker-compose up` - Start Application

### Most Useful Commands
	* `docker-compose up` - Start Application
	* `docker-compose build` - Build Application
	* `docker-compose up --force-recreate` Rebuild Application ( installs new modules )
	* `docker-machine env platform-dev` - Shows environment variables for docker machine
	* `docker-machine start platform-dev` - Starts Virtual Machine
	* `docker-machine stop platform-dev` - Stops Virtual Machine
	* `docker-machine restart platform-dev` - Restart VM ( especially when DNS starts failing )
	* `docker exec -it platform_api bash` - Enter API container
	* `docker exec -it platform_server bash` - Enter NGINX container
	* `docker exec -it platform_website bash` - Enter WEBSITE container
	* `docker exec -it platform_intranet bash` - Enter INTRANET container
	* `docker exec -it platform_database bash` - Enter POSTGRES container
	* `docker cp -r platform_api:/var/backups .` Copy data from anywhere within a container

### Bash Shell Completions
	* `brew install bash-completion`

### Fish Shell Completions (if using fish shell aka best shell out there)
	* `mkdir -p ~/.config/fish/completions`
	* `wget https://raw.github.com/barnybug/docker-fish-completion/master/docker.fish -O ~/.config/fish/completions/docker.fish`

### Login / Logout
	* `docker [login|logout]`

### Useful Docker Images (unneeded)
	* `docker pull node`
	* `docker pull nginx`
	* `docker pull redis`
	* `docker pull swarm`
	* `docker pull ubuntu`
	* `docker pull alpine`
	* `docker pull busybox`
	* `docker pull postgres`
	* `docker pull node:slim`

### Vagrant Commands
	* `vagrant up` - Start application
	* `vagrant halt` - Stop application
	* `vagrant suspend` - Pause application
	* `vagrant reload` - Reload application
	* `vagrant ssh` - Enter vagrant virtual machine

### Docker Commands
	* `docker ps -a` - Show list of docker processes
	* `docker images` - Show all local images
	* `docker run -it ubuntu bash` - Connect ubuntu to your terminal
	* `docker run -d [image] [command]` - Run in background
	* `docker logs [container-id|container-name]` - inspect output of running container
	* `docker run -d -P --name webserver nginx` - run in background and connect ports
	* `docker run -i -t -v /volume:/remote-volume platform/base-image` - attach a volume
	* `docker run -d -P -v /volume:/remote-volume nginx` - attach a volume and run in background
	* `docker [stop|start] [container-id|container-name]` - stops/start a container by id
	* `docker build -t [repository:tag] [path]` - build path into docker image
	* `docker rm [container-id]` - delete a container
	* `docker rmi [image-id]` - delete an image
	* `docker exec -it [container-id|container-name] bash` - get terminal access to any container
	* `docker tag [image-id] [Docker Hub repo:tag]` - rename local image
	* `docker pull repository:[tag] - pull from docker hub
	* `docker push repository:[tag] - push to docker hub

### Docker Compose Commands
	* `docker-compose up` - Compose for development
	* `docker-compose -f docker-compose/test.yml up -d` - Compose for testing
	* `docker-compose -f docker-compose/prod.yml up -d` - Compose for production
	* `docker-compose -f docker-compose/deploy.yml up -d` - Compose for deployment

### Docker Machine Commands
	* `docker-machine ls` - list all docker machines
	* `docker-machine ssh platform-dev` - ssh into docker machine
	* `docker-machine ip platform-dev` - get local docker ip address
	* `docker-machine env platform-dev` - view environment variables

### Docker Volumes Manager
	* `docker run -v /var/run/docker.sock:/var/run/docker.sock cpuguy83/docker-volumes list`

### Docker Swarm Commands
	* clusters docker hosts and schedules containers
	* swarm manager on remote host, and multipe nodes connect to that swarm manager

### Cleanup Commands
	* `docker rmi (docker images -qf "dangling=true")` - Clean Images
	* `docker rm -v (docker ps -q -f status=exited);` - Clean Volumes
	* `docker rm -f (docker ps --no-trunc -aq)` - Clean Containers
	* `docker volume rm $(docker volume ls -qf dangling=true)` - Destroy all Volumes

### Useful To Know (Dockerfile)
	* CMD in docker file can be overridden
	* i.e. CMD echo "Welcome to your Base Image"
	* ENTRYPOINT cannot be overridden and it is better to use exec format
	* i.e. ENTRYPOINT ["ping"]
	* Docker builds in layers. This helps to reuse caches when pulling and pushing from/to a repo
		* take this into consideration when building Dockerfiles. You want to put things that won't change much first as any changes in a caches layer will invalidate caches further down the file

### Useful Aliases
	* alias docker-update-images "docker images | awk 'BEGIN {OFS=":";}NR<2 {next}{print $1, $2}' | xargs -L1 docker pull" - `sh docker/update`
	* alias docker-clean "docker rm -v (docker ps -q -f status=exited); docker rm -f (docker ps --no-trunc -aq); docker rmi -f (docker images -qf "dangling=true")" - `sh docker/clean`
	* alias docker-deploy "docker-compose --file docker-compose/deploy.yml run deploy"

### Updating Container While Developing
	* To add a new npm package or a new bower component
		* Add the package and version to package.json or bower.json and stop your dev environment `(ctrl + c)` and restart it `sh docker/start`

### Updating A Container (Saving to Hub)
	* Enter container with something like docker run -it ubuntu bash
	* Do everything you need in the container and exit
	* Best way - add changes to Dockerfile / Docker Compose file

	* Sample steps - Manual way (never do this - but here just for reference)
		* `docker run -d -P ubuntu`
		* Install anything you want and then exit
		* `docker ps -a` - get docker id
		* `docker commit [container-id|container-name] platform/[commit-name]:[tag]` - commit the image
		* `docker images` - to see the new image created
		* 'docker run -it platform/[commit-name]:[tag]' - brings the container back up
		* e.g. `docker commit d5e705118cb4 devonte/curl:1.0` - after installing curl on an ubuntu machine
		* e.g. `docker run -it devonte/curl:1.0` - connect back to the new image

### Connecting Database
	* port - '5432'
	* user - 'jmicka'
	* password - 'Teamplatform2015!'
	* host - 'database.platform.local.com'
	* Command line - `psql postgres://jmicka:platform@database.platform.local.com:5432/platform`

### Testing
	* `docker exec -it platform_api_1 gulp test` - Runs API tests

### Deployment
	#### Setup Deployment Environment
		* `sh docker/deploy/setup` - Setup Deployment environment
		* `sh docker/deploy/init` - Initialize environment with AWS keys that lives as long as environment lives
			* so all data is gone if you run sh docker/deploy/rebuild || sh docker/deploy/destroy
			* but your keys persist even as you take up and down the container as long as above commands not run
		* `sh docker/deploy/enter` - Enter container to run further commands directly OR
		* `sh docker/deploy/run '[command]'` - Run command within container but from outside container

	#### Pull/Push Images from/to ECR
		* `sh docker/deploy/pull`
		* `sh docker/deploy/push`

	#### Deploy
		* cat docker-compose.yml | docker run --rm -i micahhausler/container-transform > Dockerrun/aws.json
		* Deployment Variables - name | description | environment | application type
		* `sh docker/deploy/images "'intranet-1.0' 'deploy docker test' 'platform-intranet' 'intranet'"`
		* OR - quickly without going through the proper steps (smh why would you even do that) (useful when images dont need to be changed)
		* `sh docker/deploy/app "'intranet-1.0' 'deploy docker test' 'platform-intranet' 'intranet'"`

	### Copy S3 Buckets
		* `sh docker/deploy/run "aws s3 sync s3://platform-testing s3://platform-website"`

### Troubleshooting
	* You will need to stop your psql from loading on startup as well
	* `sudo rm -rf /Library/LaunchDaemons/homebrew.mxcl*` - Stop your old local nginx from starting on bootup
	* If you restart and rebuild your environment a lot IP addresses might change, If this happens or you think it may have happened
		* Run `docker-machine ip platform-dev` and replace your /etc/hosts file with the value you get
	* You may get errors installing due to you hitting npm so much initially, do not be alarmed ... the idempotent build nature will allow you to start from where you last stopped-ish ( you know how npm install is *shrugs*)
	* `docker-compose logs` - Will show you logs from all containers
	* `docker-compose logs -f --tail 10` - Will show you logs from all containers tailing the last 10 lines
	* `docker inspect [container-id|container-name]` - get json output of container properties
	* `docker inspect --format [[.NetworkSettings.IPAddress]] [container-id|container-name]` - would only get ip address
	* `docker logs -f --tail 10 [container-id|container-name]` - -f tails the log; --tail shows the number of lines to tail
	* `docker-machine restart platform-dev; sh docker/start` - If your docker container seems to not be able to connect to the internet
	* `docker run -d -P -v /local/logs/nginx:/var/log/nginx nginx` - this will map the /var/log/nginx in the container to a /local/logs/nginx on the host machine
	* If you see `ERROR: Couldn't connect to Docker daemon - you might need to run `docker-machine start default`.` You may just need to rerun 'sh docker/start'