package book.user.controller;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import book.user.dto.Book;
import book.user.dto.PageList;
import book.user.service.BookService;


@Controller
@RequestMapping("/book")
public class BookController {

	@Autowired
	BookService service;

	@RequestMapping("list")
	public String list(Model model, @RequestParam(defaultValue = "1") int requestPage) {
	    PageList pageList = service.getPageList(requestPage);
	    model.addAttribute("books", pageList.getList());
	    model.addAttribute("pageList", pageList);        
	    return "book/user/list";
	}
	
	@RequestMapping("view")
	public String detail(@RequestParam("id") Long id, Model model) {
	    Book book = service.detail(id);
	    model.addAttribute("book", book);
	    return "book/user/view";
	}
}
