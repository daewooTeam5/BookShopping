package user.service;


import org.springframework.stereotype.Service;

import global.module.EncryptModule;
import lombok.RequiredArgsConstructor;
import user.dto.UserRegisterForm;
import user.entity.UserEntity;
import user.mapper.UserMapper;
import user.repository.UserRepository;

@Service
@RequiredArgsConstructor
public class UserService {
	private final  EncryptModule encryptModule;
	private final UserMapper userMapper;

	public void registerUser(UserRegisterForm user) {
		String encryptPassword = encryptModule.encryptPassword(user.getPassword());
		user.setPassword(encryptPassword);
		userMapper.save(user);
	}

	public Integer login(int id) {
		return null;
	}
	
	public UserEntity findByUserId(String userId) {
		return userMapper.findByUserId(userId);
	}

}
