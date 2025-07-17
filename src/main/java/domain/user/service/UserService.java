package domain.user.service;


import org.springframework.stereotype.Service;

import domain.user.dto.UserRegisterForm;
import domain.user.entity.UserEntity;
import domain.user.repository.UserRepository;
import global.module.EncryptModule;
import lombok.RequiredArgsConstructor;

@Service
@RequiredArgsConstructor
public class UserService {
	private final  EncryptModule encryptModule;
	private final UserRepository userMapper;

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
