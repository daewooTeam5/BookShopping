package user.entity;

import java.util.Date;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import lombok.ToString;

@ToString
@Setter
@Getter
@NoArgsConstructor
@AllArgsConstructor
public class UserEntity {

	private Long id;
	 private String userId;
	 private String password;
	 private String name;
	private String userRole;
	private Date createdAt;
	
}