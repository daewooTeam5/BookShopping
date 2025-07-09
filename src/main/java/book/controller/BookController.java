package book.controller;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import book.dto.Book;
import book.dto.PageList;
import book.service.BookService;


@Controller
@RequestMapping("/book")
public class BookController {

	@Autowired
	BookService service;

	@RequestMapping("list")
	public String list(Model model, @RequestParam(defaultValue = "1") int requestPage) {
	    PageList pageList = service.getPageList(requestPage);
	    model.addAttribute("books", pageList.getList());     // ✅ 도서 목록만 따로
	    model.addAttribute("pageList", pageList);            // ✅ 페이지 정보 따로
	    return "book/list";
	}
	
	@RequestMapping("view")
	public String detail(@RequestParam("id") Long id, Model model) {
	    Book book = service.detail(id);
	    model.addAttribute("book", book);
	    return "book/view";
	}
}
