ifneq (,$(wildcard .env))
    include .env
    export
endif

# ==================================================================================== #
# HELPERS
# ==================================================================================== #

.PHONY: help
## help: print this help message
help:
	@echo 'Usage:'
	@sed -n 's/^##//p' ${MAKEFILE_LIST} | column -t -s ':' | sed -e 's/^/ /'

.PHONY: confirm
confirm: 
	@echo -n 'Are you sure? [y/N] ' && read ans && [ $${ans:-N} = y]

# ==================================================================================== #
# DEVELOPMENT
# ==================================================================================== #

.PHONY: run/api
## run/api: run the cmd/api application
run/api:
	go run ./cmd/api -db-dsn=${GREENLIGHT_DB_DSN}

.PHONY: db/psql
## db/psql: connect to the database using psql
db/psql:
	psql ${GREENLIGHT_DB_DSN}

.PHONY: db/migrations/new
## db/migrations/new name=$1: create a new database migration
db/migrations/new:
	@echo 'Creating migration files for ${name}...'
	migrate create -seq -ext=.sql -dir=./migrations ${name}

.PHONY: db/migrations/up
## db/migrations/up: apply all up database migrations
db/migrations/up: confirm
	@echo 'Running up migrations...'
	migrate -path ./migrations -database ${GREENLIGHT_DB_DSN} up


# ==================================================================================== #
# QUALITY CONTROL
# ==================================================================================== #

## audit: tidy and vendor dependencies and format, vet and test all code
.PHONY: audit
audit: vendor
	@echo 'Formatting code...'
	go fmt ./...
	@echo 'Vetting code...'
	go vet ./...
	staticcheck ./...
	@echo 'Running tests...'
	go test -race -vet=off ./...

## vendor: tidy and vendor dependencies
.PHONY: vendor
vendor:
	@echo 'Tidying and verifying module dependencies...'
	go mod tidy
	go mod verify
	@echo 'Vendoring dependencies...'
	go mod vendor

## build/api: build the cmd/api applicationls 

.PHONY: build/api
build/api:
	@echo "Building for Windows..."
	go build -ldflags="-s" -o=./bin/api ./cmd/api
	@echo "Building for Linux..."
	powershell -Command "Set-Item -Path Env:GOOS -Value 'linux'"
	go build -ldflags='-s' -o=./bin/linux_amd64/api ./cmd/api

	@echo "SUCCESS"
