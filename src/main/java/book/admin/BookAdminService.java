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
	    // 업로드 폴더 경로 (경로는 운영 환경에 맞게 조정)
		String realPath = request.getServletContext().getRealPath("/img");

	    // 업로드할 파일명
	    String originalName = imageFile.getOriginalFilename();

	    // 실제 저장될 전체 경로
	    File saveFile = new File(realPath, originalName);
	    try {
	        // 파일이 비어있지 않으면 저장
	        if (!imageFile.isEmpty()) {
	            imageFile.transferTo(saveFile);
	        }

	        // 책 객체에 파일명 저장 (DB에 저장할 용도)
	        book.setImage(originalName);

	        // DB 저장
	        int result = mapper.save(book);
	        return result > 0;

	    } catch (Exception e) {
	        e.printStackTrace();
	        return false;
	    }
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
