package main

import (
	"github.com/jinzhu/gorm"
	pb "github.com/thrucker/user-service/proto/user"
)

type Repository interface {
	GetAll() ([]*pb.User, error)
	Get(id string) (*pb.User, error)
	Create(user *pb.User) error
	GetByEmailAndPassword(user *pb.User) (*pb.User, error)
	GetByEmail(email string) (*pb.User, error)
}

type UserRepository struct {
	db *gorm.DB
}

func (repo *UserRepository) GetAll() ([]*pb.User, error) {
	var users []*pb.User
	err := repo.db.Find(&users).Error
	return users, err
}

func (repo *UserRepository) Get(id string) (*pb.User, error) {
	var user *pb.User
	user.Id = id
	err := repo.db.First(&user).Error
	return user, err
}

func (repo *UserRepository) GetByEmailAndPassword(user *pb.User) (*pb.User, error) {
	err := repo.db.First(&user).Error
	return user, err
}

func (repo *UserRepository) GetByEmail(email string) (*pb.User, error) {
	user := &pb.User{}
	err := repo.db.Where("email = ?", email).First(&user).Error
	return user, err
}

func (repo *UserRepository) Create(user *pb.User) error {
	return repo.db.Create(user).Error
}
