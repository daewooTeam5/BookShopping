package book.admin;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

@Service("bookAdminService")
public class BookAdminService {
	@Autowired
	BookAdminMapper mapper;
	
	public BookAdminService() {
	}
	
	public List<Book> findAll(){
		return mapper.findAll();
	}
	
	public List<Book> searchByField(String field, String keyword) {
	    return mapper.searchByField(field, keyword);
	}
	
}
