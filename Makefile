ROOT_DIR:=$(shell dirname $(realpath $(firstword $(MAKEFILE_LIST))))
UID := $(shell id -u)
CONTAINER:=ffmpeg_logo_overlay

start:
	@docker run -it --rm -d --name $(CONTAINER) -v $(ROOT_DIR)/app:/app -w /app php:7.4-cli

stop:
	@docker stop $(CONTAINER)

bash:
	@docker exec -it $(CONTAINER) bash

deps:
	@-docker exec $(CONTAINER) useradd worker >/dev/null 2>&1
	@-docker exec $(CONTAINER) usermod -u $(UID) worker >/dev/null 2>&1
	@docker exec $(CONTAINER) curl https://getcomposer.org/download/latest-2.2.x/composer.phar -so /bin/composer
	@docker exec $(CONTAINER) chmod +x /bin/composer
	@docker exec $(CONTAINER) apt-get update
	@docker exec $(CONTAINER) apt-get install -y ffmpeg libzip-dev git zip
	@docker exec $(CONTAINER) composer install

sample:
	@docker exec $(CONTAINER) curl https://file-examples-com.github.io/uploads/2017/04/file_example_MP4_1920_18MG.mp4 -o app/data/sample.mp4

magic:
	@docker exec -u $(UID) $(CONTAINER) php add_watermark.php
