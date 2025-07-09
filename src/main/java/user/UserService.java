package user;



import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.stereotype.Service;

@Service
public class UserService {
	@Qualifier("oracleUserDAO")
	@Autowired
	
	UserDAO dao;

public int login(int id) {
	return dao.login(id);
}
	

}
