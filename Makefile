.PHONY: build run proto

run: build
	docker run -p 50051:50051 \
		-e MICRO_SERVER_ADDRESS=:50051 \
		shippy-service-user

proto: proto/user/user.pb.go

proto/user/user.pb.go: proto/user/user.proto
	protoc -I. --go_out=plugins=micro:. proto/user/user.proto

.build/.docker-container.stamp: Dockerfile main.go proto/user/user.pb.go go.mod go.sum database.go handler.go repository.go token_service.go
	docker build -t shippy-service-user .
	mkdir -p $(dir $@)
	touch $@

build: .build/.docker-container.stamp
