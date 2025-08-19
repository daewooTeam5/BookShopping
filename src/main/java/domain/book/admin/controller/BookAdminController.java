package domain.book.admin.controller;

import java.io.IOException;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.ModelAndView;

import domain.book.admin.entity.Book;
import domain.book.admin.service.BookAdminService;

@Controller
@RequestMapping("/book/admin")
public class BookAdminController {
    private BookAdminService service;

    @Autowired
    public BookAdminController(BookAdminService service) {
        this.service = service;
    }

    @RequestMapping("list")
    public ModelAndView list(
        @RequestParam(value = "searchField", required = false, defaultValue = "title") String searchField,
        @RequestParam(value = "keyword", required = false) String keyword,
        @RequestParam(value = "showDeleted", required = false) String showDeleted,
        ModelAndView mv) {

        // 삭제된 책까지 포함해서 보여줄지 결정
        boolean includeDeleted = "Y".equals(showDeleted);

        if (keyword != null && !keyword.isEmpty()) {
            if (includeDeleted) {
                mv.addObject("list", service.searchByFieldWithDeleted(searchField, keyword));
            } else {
                mv.addObject("list", service.searchByField(searchField, keyword));
            }
        } else {
            if (includeDeleted) {
                mv.addObject("list", service.findAllWithDeleted());
            } else {
                mv.addObject("list", service.findAll());
            }
        }

        mv.addObject("searchField", searchField);
        mv.addObject("keyword", keyword);
        mv.addObject("showDeleted", showDeleted); // 체크박스 상태 유지용
        mv.setViewName("book/admin/list");
        return mv;
    }

    @RequestMapping("writeform")
    public String writeForm() {
        return "book/admin/writeform";
    }

    @PostMapping("write")
    public void write(Book book, @RequestParam("imageFile") MultipartFile imageFile, HttpServletRequest request, HttpServletResponse response) throws IOException {
        boolean success = service.save(book, imageFile, request);

        response.setContentType("text/html; charset=UTF-8");
        response.setCharacterEncoding("UTF-8");

        if (success) {
            response.getOutputStream().write("<script>alert('Write Success!'); location.href='/book/admin/list';</script>".getBytes());
        } else {
            response.getOutputStream().write("<script>alert('Write Fail!'); history.back();</script>".getBytes());
        }
    }

    @RequestMapping("updateform")
    public ModelAndView updateform(int id, ModelAndView mv)
    {
        mv.addObject("book",service.findById(id));
        mv.setViewName("book/admin/updateform");
        return mv;
    }

    @PostMapping("update")
    public void update(
            Book book,
            @RequestParam("imageFile") MultipartFile imageFile,
            @RequestParam("originalImage") String originalImage,
            HttpServletRequest request,
            HttpServletResponse response) {

        // 이미지가 비어있다면 기존 이미지 유지
        if (imageFile == null || imageFile.isEmpty()) {
            book.setImage(originalImage);  // 기존 이미지 유지
        }

        boolean success = service.update(book, imageFile, request);

        response.setContentType("text/html; charset=UTF-8");
        response.setCharacterEncoding("UTF-8");

        try {
            if (success) {
                response.getOutputStream().write("<script>alert('Update Success!'); location.href='/book/admin/list';</script>".getBytes());
            } else {
                response.getOutputStream().write("<script>alert('Update Fail!'); history.back();</script>".getBytes());
            }
        } catch (IOException e) {
            e.printStackTrace();
        }
    }

    @PostMapping("delete")
    public void delete(@RequestParam("id") int id, HttpServletResponse response) {
        boolean success = service.delete(id);

        response.setContentType("text/html; charset=UTF-8");
        response.setCharacterEncoding("UTF-8");

        try {
            if (success) {
                response.getOutputStream().write("<script>alert('Delete Success!'); location.href='/book/admin/list';</script>".getBytes());
            } else {
                response.getOutputStream().write("<script>alert('Delete Fail!'); history.back();</script>".getBytes());
            }
        } catch (IOException e) {
            e.printStackTrace();
        }
    }
}
