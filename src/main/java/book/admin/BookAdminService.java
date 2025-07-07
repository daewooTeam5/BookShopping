package book.admin;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

@Service("bookAdminService")
public class BookAdminService {
	@Autowired
	BookAdminMapper mapper;
	
	public BookAdminService() {
		System.out.println("Book Admin service!!");
	}
	
	public List<Book> findAll(){
		System.out.println("===================================="+mapper.findAll());
		return mapper.findAll();
	}
}
