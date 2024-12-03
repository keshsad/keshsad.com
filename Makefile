.PHONY: all build run restart status deploy

# variables
APP_NAME = keshsad
SERVICE_NAME_DEV = dev-keshsad-com.service
SERVICE_NAME_PROD = keshsad-com.service
PORT ?= 42069
ENV ?= DEV

all: build

build:
	@echo "building site... 🏗️"
	PORT=$(PORT) ENV=$(ENV) go build -o ./cmd/$(APP_NAME) ./cmd/server/main.go

run:
	@echo "running air... 💨"
	PORT=$(PORT) ENV=$(ENV) air

restart:
	@echo "restarting service... 🌀"
	ifeq ($(ENV),DEV)
		sudo systemctl restart $(SERVICE_NAME_DEV)
		@echo "development service restarted ✅"
	else ifeq ($(ENV),PROD)
		sudo systemctl restart $(SERVICE_NAME_PROD)
		@echo "production service restarted ✅"

status: restart
	@echo "checking status... 🚦"
	ifeq ($(ENV),DEV)
		sudo systemctl status $(SERVICE_NAME_DEV)
	else ifeq ($(ENV),PROD)
		sudo systemctl status $(SERVICE_NAME_PROD)

deploy:
	@echo "deploying... 🛩️"
	ifeq ($(ENV),DEV)
		@echo "add, commit, push to dev, then make restart!"
	else ifeq ($(ENV),PROD)
		@echo "checkout and merge dev to main, then make restart!"
	@echo "make status to finish deployment!"
