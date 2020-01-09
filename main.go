package main

import (
	"fmt"
	"github.com/micro/go-micro"
	pb "github.com/thrucker/user-service/proto/user"
	"log"
)

func main() {
	db, err := CreateConnection()
	if err != nil {
		log.Fatalf("Could not conncet to DB: %v", err)
	}
	defer db.Close()

	db.AutoMigrate(&pb.User{})

	repo := &UserRepository{db}

	srv := micro.NewService(
		micro.Name("go.micro.srv.user"),
		micro.Version("latest"),
	)

	srv.Init()

	pb.RegisterUserServiceHandler(srv.Server(), &service{repo})

	if err := srv.Run(); err != nil {
		fmt.Println(err)
	}
}
