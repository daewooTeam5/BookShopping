package domain.user.repository;

import domain.user.entity.UserEntity;

public interface UserRepository {
	int save(UserEntity entity);
}
