.PHONY: run build dev prod

export APP_NAME = keshsad
SERVICE_NAME_DEV = dev-keshsad-com.service
SERVICE_NAME_PROD = keshsad-com.service
export PORT ?= 42069
export ENV ?= DEV

run:
	@echo "running air... 🚀"
	~/go/bin/air

build:
	@echo "building site... 🏗"
	go build -o ./cmd/$(APP_NAME) ./cmd/server
	chmod +x ./cmd/$(APP_NAME)

dev:
	@if [ "$(shell uname)" = "Darwin" ]; then \
		PORT=$(PORT) ENV=$(ENV) air; \
	else \
		sudo systemctl restart $(SERVICE_NAME_DEV); \
	fi

prod:
	@if [ "$(shell uname)" = "Darwin" ]; then \
		PORT=8000 ENV=PROD go run cmd/server/main.go; \
	else \
		sudo systemctl restart $(SERVICE_NAME_PROD); \
	fi

