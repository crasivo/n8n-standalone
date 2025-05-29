MAKEARGS = $(filter-out $@,$(MAKECMDGOALS))
MAKEGID = $(shell id -g)
MAKEUID = $(shell id -u)
MAKEDIR := ${CURDIR}
MAKEFLAGS += --silent

# Specifies
DUMPDATE := $(shell date '+%Y%m%d_%H%M%S')
VENDOR := crasivo

# Default command for 'make'
_list_commands:
	sh -c "echo; $(MAKE) -p no_targets__ | awk -F':' '/^[a-zA-Z0-9][^\$$#\/\\t=]*:([^=]|$$)/ {split(\$$1,A,/ /);for(i in A)print A[i]}' | grep -v '__\$$' | grep -v 'Makefile'| sort"

# ----------------------------------------------------------------
# Secrets
# ----------------------------------------------------------------

check-secrets:
	mkdir -p secrets
	if [ ! -f ./secrets/n8n_postgres.pass ]; then tr -dc A-Za-z0-9 < /dev/urandom | head -c 20 > ./secrets/n8n_postgres.pass; fi
	if [ ! -f ./secrets/n8n_encryption.key ]; then tr -dc a-f0-9 < /dev/urandom | head -c 64 > ./secrets/n8n_encryption.key; fi

# ----------------------------------------------------------------
# Local: Init
# ----------------------------------------------------------------

npm-init: check-secrets
	cp -f .env.minimal .env
	npm install
	npm run start
local-init: npm-init

# ----------------------------------------------------------------
# Docker: Init
# ----------------------------------------------------------------

docker-init-extended: check-secrets
	cp -f docker-compose.extended.yml docker-compose.yml
	touch .env
	docker compose up -d
docker-init-minimal: check-secrets
	cp -f docker-compose.minimal.yml docker-compose.yml
	touch .env
	docker compose up -d
docker-init: docker-init-minimal

# ----------------------------------------------------------------
# Docker: Build
# ----------------------------------------------------------------

docker-build:
	docker image build --compress -f 'Dockerfile.alpine' -t "$(VENDOR)/n8n-standalone:latest" -t "$(VENDOR)/n8n-standalone:alpine" .

# ----------------------------------------------------------------
# Docker: Push
# ----------------------------------------------------------------

docker-push:
	if [ -f .docker-registry.key ]; then cat .docker-registry.key | docker login -u $(VENDOR) --password-stdin; fi
	docker image push $(VENDOR)/n8n-standalone -a
	if [ -f .docker-registry.key ]; then docker logout; fi

# ----------------------------------------------------------------
# Docker: Compose
# ----------------------------------------------------------------

_docker_compose_check: check-secrets
	if [ ! -f docker-compose.yml ]; then cp docker-compose.minimal.yml docker-compose.yml fi
	touch .env

docker-up:
	docker compose up -d
docker-down:
	docker compose down
docker-start:
	docker compose start
docker-stop:
	docker compose stop

# ----------------------------------------------------------------
# Docker: Dump
# ----------------------------------------------------------------

docker-dump-n8n:
	mkdir -p ./dumps/$(DUMPDATE)_n8n_data
	docker compose cp app:/app/.n8n/. ./dumps/$(DUMPDATE)_n8n_data
	tar -czf ./dumps/$(DUMPDATE)_n8n_data.tar.gz -C ./dumps/$(DUMPDATE)_n8n_data .
	rm -rf ./dumps/$(DUMPDATE)_n8n_data
docker-dump-postgres:
	mkdir -p ./dumps/$(DUMPDATE)_postgres_data
	docker compose cp postgres:/var/lib/postgresql/data/. ./dumps/$(DUMPDATE)_postgres_data
	tar -czf ./dumps/$(DUMPDATE)_postgres_data.tar.gz -C ./dumps/$(DUMPDATE)_postgres_data .
	rm -rf ./dumps/$(DUMPDATE)_postgres_data
docker-dump: \
	docker-dump-postgres \
	docker-dump-n8n

# ----------------------------------------------------------------
# Local: Dump
# ----------------------------------------------------------------

local-dump-n8n:
	mkdir -p ./dumps/$(DUMPDATE)_n8n_data
	tar -czf ./dumps/$(DUMPDATE)_n8n_data.tar.gz -C .n8n .
	rm -rf ./dumps/$(DUMPDATE)_n8n_data
local-dump: \
	local-dump-n8n

# Fix arguments
%:
	@:
