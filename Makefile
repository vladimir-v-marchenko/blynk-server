DOCKER_IMAGE_VERSION=latest
DOCKER_IMAGE_NAME=burzum/alpine-blynk
DOCKER_IMAGE_TAGNAME=$(DOCKER_IMAGE_NAME):$(DOCKER_IMAGE_VERSION)
DOCKER_CONTAINER_NAME=blynk-server

default: build

build:
	docker build -t $(DOCKER_IMAGE_TAGNAME) .
	docker tag $(DOCKER_IMAGE_TAGNAME) $(DOCKER_IMAGE_NAME)

push:
	docker push $(DOCKER_IMAGE_NAME)

rm:
	docker rm $(DOCKER_CONTAINER_NAME)

rmi:
	docker rmi $(DOCKER_IMAGE_NAME):$(DOCKER_IMAGE_VERSION)

test:
	docker run $(DOCKER_IMAGE_TAGNAME) /bin/echo "Success."

version:
	docker run --rm $(DOCKER_IMAGE_TAGNAME) /bin/cat /etc/issue

run:
	docker run -d -v `pwd`/data/data:/app/data -v `pwd`/data/logs:/app/logs \
		-p 7443:7443 -p 8080:8080 -p 8081:8081 -p 8082:8082 \
		-p 8441:8441 -p 8442:8442 -p 8443:8443 -p 9443:9443 \
		--name $(DOCKER_CONTAINER_NAME) \
		-t $(DOCKER_IMAGE_TAGNAME)

