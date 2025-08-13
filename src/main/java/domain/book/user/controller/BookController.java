package domain.book.user.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import domain.book.user.dto.Book;
import domain.book.user.dto.PageList;
import domain.book.user.service.BookService;


@Controller
@RequestMapping("/book")
public class BookController {

	@Autowired
	BookService service;

	@RequestMapping("list")
	public String list(
	    Model model,
	    @RequestParam(defaultValue = "1") int requestPage,
	    @RequestParam(value = "searchField", required = false, defaultValue = "title") String searchField,
	    @RequestParam(value = "keyword", required = false) String keyword,
	    @RequestParam(value = "genre", required = false) String genre) {

	    PageList pageList = service.getPageList(requestPage, searchField, keyword, genre);
	    model.addAttribute("books", pageList.getList());
	    model.addAttribute("pageList", pageList);
	    model.addAttribute("searchField", searchField);
	    model.addAttribute("keyword", keyword);
	    model.addAttribute("genre", genre);

	    model.addAttribute("genreList", service.getGenreCounts());
	    return "book/user/list";
	}

	
	@RequestMapping("view")
	public String detail(@RequestParam("id") Long id, Model model) {
	    Book book = service.detail(id);
	    model.addAttribute("book", book);
	    return "book/user/view";
	}
}
