package global.module;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Component;

@Component
public class EncryptModule {
	@Autowired
	private PasswordEncoder passwordEncoder;

	public String encryptPassword(String password) {
		return passwordEncoder.encode(password);
	}

	public Boolean validatePassword(String originalPassword, String encryptedPassword) {
		return passwordEncoder.matches(originalPassword, encryptedPassword);
	}
}
