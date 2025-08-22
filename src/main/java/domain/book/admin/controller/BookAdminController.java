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
        @RequestParam(value = "page", required = false, defaultValue = "1") int page,   // ★ 추가: 페이지 파라미터
        ModelAndView mv) {

        boolean includeDeleted = "Y".equals(showDeleted);
        int size = 10; // ★ 한 페이지 10개
        int total = 0;
        int totalPages = 1;

        // 검색어나 삭제 포함이면 기존 방식 유지(전체 출력), 페이징은 표시만 1페이지로 고정
        if (keyword != null && !keyword.isEmpty()) {
            if (includeDeleted) {
                mv.addObject("list", service.searchByFieldWithDeleted(searchField, keyword));
            } else {
                mv.addObject("list", service.searchByField(searchField, keyword));
            }
            total = ( (java.util.List<?>) mv.getModel().get("list") ).size();
            totalPages = 1; // 페이징 비활성화 느낌으로 1페이지 고정
            page = 1;
        } else if (includeDeleted) {
            mv.addObject("list", service.findAllWithDeleted());
            total = ( (java.util.List<?>) mv.getModel().get("list") ).size();
            totalPages = 1; // 페이징 비활성화 느낌으로 1페이지 고정
            page = 1;
        } else {
            // ★ 기본 목록(삭제 N, 검색 X)에는 페이징 적용
            total = service.countAll();
            totalPages = (int) Math.ceil(total / (double) size);
            if (totalPages == 0) totalPages = 1;
            if (page < 1) page = 1;
            if (page > totalPages) page = totalPages;

            mv.addObject("list", service.findPage(page, size));
        }

        mv.addObject("searchField", searchField);
        mv.addObject("keyword", keyword);
        mv.addObject("showDeleted", showDeleted);

        // ★ 페이징 메타데이터 전달
        mv.addObject("page", page);
        mv.addObject("size", size);
        mv.addObject("total", total);
        mv.addObject("totalPages", totalPages);

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

        // 이미지가 비어있으면 기존 이미지 유지
        if (imageFile == null || imageFile.isEmpty()) {
            book.setImage(originalImage);
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
