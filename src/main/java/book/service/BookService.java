package book.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import book.dao.BookDao;
import book.dto.Book;


@Service
public class BookService {

	@Autowired
	BookDao dao;
	
	public List<Book> list(){
		return dao.findAll();
	}
	
	public Book detail(int id) {
		return dao.findById(id);
	}
}
