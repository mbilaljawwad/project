FRONT_END_BINARY = frontApp
BROKER_BINARY = brokerApp
AUTH_BINARY = authApp

## up: starts all container in the background without forcing build.
up:
	@echo "Starting all containers."
	docker-compose up -d
	@echo "All containers started."

## up_build: Builds all projects and starts docker-compose.
up_build: build_broker build_auth
	@echo "Building (when required) and starting all containers."
	docker-compose up --build -d
	@echo "Docker containers are built and started."

## stop: stop docker compose
stop: 
	@echo "Stopping docker compose."
	docker-compose stop
	@echo "Done!"	

## down: stops and removes all containers.
down:
	@echo "Stopping and removing all containers."
	docker-compose down
	@echo "All containers stopped and removed."

## build_broker: Build the broker binary as a linux executable.
build_broker:
	@echo "Building broker binary."
	cd ../broker-service && env GOOS=linux CGO_ENABLED=0 go build -o ${BROKER_BINARY} ./cmd/api
	@echo "Done!"


## build_auth: Build the auth binary as a linux executable.
build_auth:
	@echo "Building auth binary."
	cd ../authentication-service && env GOOS=linux CGO_ENABLED=0 go build -o ${AUTH_BINARY} ./cmd/api
	@echo "Done!"

## build_front: Build the frontend binary.
build_front:
	@echo "Building front-end binary."
	cd ../broker-app-frontend && env CGO_ENABLED=0 go build -o ${FRONT_END_BINARY} ./cmd/web
	@echo "Done!"	

## start: starts the frontend.
start: build_front
	@echo "Starting front-end."
	cd ../broker-app-frontend && ./${FRONT_END_BINARY}

## stop_frontend: stops the frontend.
stop_frontend:
	@echo "Stopping front-end."
	@-pkill -SIGTERM -f ./${FRONT_END_BINARY}
	@echo "Done!"	