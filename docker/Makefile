#ENV
USER_NAME=deron73
CRAWLER_UI_VERSION=1.0
CRAWLER_ENGINE_VERSION=1.0

# DOCKER BUILDS
build:: build-crawler-engine build-crawler-ui 

build-crawler-engine::
	cd ../source/search_engine_crawler/ && \
	docker build --no-cache -t $(USER_NAME)/crawler-engine:$(CRAWLER_ENGINE_VERSION) .
build-crawler-ui::
	cd ../source/search_engine_ui/ && \
	docker build --no-cache -t $(USER_NAME)/crawler-ui:$(CRAWLER_UI_VERSION) .