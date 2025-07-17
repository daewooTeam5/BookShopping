package global.security;

import org.springframework.security.core.userdetails.User;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.stereotype.Service;

import domain.user.entity.UserEntity;
import domain.user.repository.UserRepository;
import lombok.RequiredArgsConstructor;

@Service("loginServiceWithSecurity")
@RequiredArgsConstructor
public class LoginServiceWithSecurity implements UserDetailsService {
	private final UserRepository mapper;

	@Override
	public UserDetails loadUserByUsername(String username) throws UsernameNotFoundException {
		System.out.println(username);
		UserEntity findUser = mapper.findByUserId(username);
		System.out.println(findUser);
		if(findUser==null) {
			throw new IllegalStateException("존재하지 않는 유저 입니다.");
		}
		
		return User.withUsername(username)
				.password(findUser.getPassword())
				.authorities(findUser.getUserRole())
				.build();
	}

}
