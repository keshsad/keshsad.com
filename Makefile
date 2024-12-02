.PHONY: all build run restart status deploy

# variables
APP_NAME=keshsad
SERVICE_NAME=dev-keshsad-com.service
PORT=42069

all: build

build:
	@echo "building site... 🏗️"
	go build -o $(APP_NAME) ./cmd/server/main.go

run:
	@echo "running air... 💨"
	air

status:
	@echo "checking status... 🚦"
	sudo systemctl status $(SERVICE_NAME)

restart: status
	@echo "restarting service... 🌀"
	sudo systemctl restart $(SERVICE_NAME)
	@echo "service restarted ✅"

deploy:
	@echo "deploying... 🛩️"
	git checkout main
	git merge dev
	git push origin main
	@echo "run `make restart` then `make status` to finish deployment"
