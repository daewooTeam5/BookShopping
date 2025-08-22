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

    public List<Book> findAll() {
        return mapper.findAll();
    }

    public List<Book> searchByField(String field, String keyword) {
        return mapper.searchByField(field, keyword);
    }

    public List<Book> findAllWithDeleted() {
        return mapper.findAllWithDeleted();
    }

    public List<Book> searchByFieldWithDeleted(String field, String keyword) {
        return mapper.searchByFieldWithDeleted(field, keyword);
    }

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

    public Book findById(int id) {
        return mapper.findById(id);
    }

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

    public boolean delete(int id) {
        int result = mapper.delete(id);
        return result > 0;
    }

    public boolean restore(int id) {
        return mapper.restore(id) > 0;
    }

    // 총 개수 (is_deleted = 'N')
    public int countAll() {
        return mapper.countAll();
    }

    // 페이지는 1부터 시작, size는 1 이상
    public List<Book> findPage(int page, int size) {
        if (page < 1) page = 1;
        if (size < 1) size = 10;
        int startRow = (page - 1) * size + 1; // 1, 11, 21 ...
        int endRow   = page * size;           // 10, 20, 30 ...
        return mapper.findPage(startRow, endRow);
    }

    // 편의 메서드: 기본 10개씩
    public List<Book> findPage(int page) {
        return findPage(page, 10);
    }
}
