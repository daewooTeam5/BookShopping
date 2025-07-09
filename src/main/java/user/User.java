package user;

import java.sql.Date;

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

public class User {

	private int id;
	 private String userid;
	 private String password;
	 private String name;
	private String user_role;
	private Date created_at;
	
}
