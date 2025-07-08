package book.admin;

import java.io.File;
import java.util.List;

import javax.servlet.http.HttpServletRequest;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

@Service("bookAdminService")
public class BookAdminService {
	@Autowired
	BookAdminMapper mapper;

	public BookAdminService() {
	}

	public List<Book> findAll() {
		return mapper.findAll();
	}

	public List<Book> searchByField(String field, String keyword) {
		return mapper.searchByField(field, keyword);
	}

	public boolean save(Book book, MultipartFile imageFile, HttpServletRequest request) {
		String realPath = request.getServletContext().getRealPath("/img/");
		String filename=imageFile.getOriginalFilename();
		String fullname = realPath + File.separator + filename;
		
		try {
			if (!imageFile.isEmpty()) {
				imageFile.transferTo(new File(fullname));
			}
		}catch (Exception e) {
			e.printStackTrace();
		}
		book.setImage(filename);
		int result = mapper.save(book);
		return result > 0; // 저장 성공 여부 반환
	}

	public Book findById(int id) {
		return mapper.findById(id);
	}

	public boolean update(Book book, MultipartFile imageFile, HttpServletRequest request) {
		
		return false;
	}

	
}
