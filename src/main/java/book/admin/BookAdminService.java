package book.admin;

import java.io.File;
import java.io.IOException;
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
	    try {
	        // 이미지가 새로 업로드된 경우
	        if (imageFile != null && !imageFile.isEmpty()) {
	            String fileName = imageFile.getOriginalFilename();
	            String savePath = request.getServletContext().getRealPath("/img");
	            File file = new File(savePath, fileName);
	            imageFile.transferTo(file); // 저장
	            book.setImage(fileName);    // Book 객체에 이미지 파일명 설정
	        }

	        return mapper.update(book) > 0;
	    } catch (Exception e) {
	        e.printStackTrace();
	        return false;
	    }
	}

	public boolean delete(int id) {
		int result = mapper.delete(id);
	    return result > 0;
	}	
}
