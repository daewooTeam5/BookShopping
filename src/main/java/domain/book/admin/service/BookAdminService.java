package domain.book.admin.service;

import java.io.File;
import java.util.List;

import javax.servlet.http.HttpServletRequest;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

import domain.book.admin.entity.Book;
import domain.book.admin.repository.BookAdminRepository;

@Service("bookAdminService")
public class BookAdminService {
    @Autowired
    BookAdminRepository mapper;

    public BookAdminService() {}

    // 삭제 안 된 책 전체 조회
    public List<Book> findAll() {
        return mapper.findAll();
    }

    // 삭제 안 된 책 검색
    public List<Book> searchByField(String field, String keyword) {
        return mapper.searchByField(field, keyword);
    }

    // [★] 삭제된 책 포함 전체 조회 (관리자용)
    public List<Book> findAllWithDeleted() {
        return mapper.findAllWithDeleted();
    }

    // [★] 삭제된 책 포함 검색 (관리자용)
    public List<Book> searchByFieldWithDeleted(String field, String keyword) {
        return mapper.searchByFieldWithDeleted(field, keyword);
    }

    // 책 등록
    public boolean save(Book book, MultipartFile imageFile, HttpServletRequest request) {
        String realPath = request.getServletContext().getRealPath("/img");
        String originalName = imageFile.getOriginalFilename();
        File saveFile = new File(realPath, originalName);
        try {
            if (!imageFile.isEmpty()) {
                imageFile.transferTo(saveFile);
            }
            book.setImage(originalName);
            int result = mapper.save(book);
            return result > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    // 상세조회(삭제X만)
    public Book findById(int id) {
        return mapper.findById(id);
    }

    // 수정(삭제X만)
    public boolean update(Book book, MultipartFile imageFile, HttpServletRequest request) {
        try {
            if (imageFile != null && !imageFile.isEmpty()) {
                String fileName = imageFile.getOriginalFilename();
                String savePath = request.getServletContext().getRealPath("/img");
                File file = new File(savePath, fileName);
                imageFile.transferTo(file);
                book.setImage(fileName);
            }
            return mapper.update(book) > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    // 논리적 삭제
    public boolean delete(int id) {
        int result = mapper.delete(id);
        return result > 0;
    }
}
