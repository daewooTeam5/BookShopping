package book.controller;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import book.dto.Book;
import book.service.BookService;


@Controller
@RequestMapping("/book")
public class BookController {

	@Autowired
	BookService service;

	@RequestMapping("list")
	public String list(Model model) {
		System.out.println("list");
		List<Book> list = service.list();
		model.addAttribute("book", list);
		return "book/list";
	}
	
	@RequestMapping("view")
	public String detail(@RequestParam("id") Long id, Model model) {
	    Book book = service.detail(id);
	    model.addAttribute("book", book);
	    return "book/view";
	}
}
