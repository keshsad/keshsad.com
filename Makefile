.PHONY: run build restart status dev prod

APP_NAME = keshsad
SERVICE_NAME_DEV = dev-keshsad-com.service
SERVICE_NAME_PROD = keshsad-com.service
export PORT ?= 42069
export ENV ?= DEV

run:
	@echo "running air... 💨"
	PORT=$(PORT) ENV=$(ENV) ~/go/bin/air

build:
	@echo "building site... 🏗️"
	PORT=$(PORT) ENV=$(ENV) go build -o ./cmd/$(APP_NAME) ./cmd/server
	chmod +x ./cmd/$(APP_NAME)

restart: build
	@echo "restarting service... 🌀"
	ifeq ($(ENV),DEV)
		sudo systemctl restart $(SERVICE_NAME_DEV)
		@echo "development service restarted ✅"
	else ifeq ($(ENV),PROD)
		sudo systemctl restart $(SERVICE_NAME_PROD)
		@echo "production service restarted ✅"
	endif

status: restart
	@echo "checking status... 🚦"
	ifeq ($(ENV),DEV)
		sudo systemctl status $(SERVICE_NAME_DEV)
	else ifeq ($(ENV),PROD)
		sudo systemctl status $(SERVICE_NAME_PROD)
	endif

dev:
	@if [ "$(shell uname)" = "Darwin" ]; then \
		PORT-42069 ENV=DEV air; \
	else \
		sudo systemctl restart $(SERVICE_NAME_DEV)
	fi

prod:
	@if [ "$(shell uname) = "Darwin" ]; then \
		PORT=8000 ENV=PROD go run cmd/server/main.go; \
	else \
		sudo systemctl restart $(SERVICE_NAME_PROD)
	fi
