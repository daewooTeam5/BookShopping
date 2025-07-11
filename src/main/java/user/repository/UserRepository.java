package user.repository;

import user.entity.UserEntity;

public interface UserRepository {
	int save(UserEntity entity);
}
