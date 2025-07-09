package book.service;

import java.sql.Date;
import java.util.ArrayList;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import book.dao.BookDao;
import book.dto.Book;
import book.dto.PageList;


@Service
public class BookService {

	@Autowired
	BookDao dao;
	
	public Book detail(Long id) {
		return dao.findById(id);
	}
	
	public PageList getPageList(int requestPage) {
		try {
			PageList pageList = PageList.builder().totalCount(dao.count()).pagePerCount(10).build();

			int totalPage = 0;
			if ((pageList.getTotalCount() % pageList.getPagePerCount()) == 0) {
				totalPage = pageList.getTotalCount() / pageList.getPagePerCount();
			} else {
				totalPage = (pageList.getTotalCount() / pageList.getPagePerCount()) + 1;
			}
			pageList.setTotalPage(totalPage);

			pageList.setCurrentPage(requestPage);
			int startnum = ((requestPage - 1) * pageList.getPagePerCount()) + 1;
			int endnum = requestPage * pageList.getPagePerCount();

			int startPage = ((requestPage - 1) / 5 * 5) + 1;
			int endPage = startPage + (5 - 1);
			if (endPage > totalPage)
				endPage = totalPage;
			pageList.setStartPage(startPage);
			pageList.setEndPage(endPage);

			boolean isPre = requestPage > 5 ? true : false;
			boolean isNext = endPage < totalPage ? true : false;
			pageList.setPre(isPre);
			pageList.setNext(isNext);
			
			List<Book> list = dao.findAll(startnum, endnum);

			List<Book> booklists = new ArrayList<Book>();
			for (Book book : list) {
				Book booklist = new Book(book.getId() ,book.getTitle(), book.getAuthor(), book.getPublisher(),
						book.getImage(), book.getPrice(), book.getGenre(), book.getPublished_at(), book.getPage(), book.getIntroduction());
				booklists.add(booklist);
			}
			pageList.setList(booklists);
			return pageList;
		} catch (Exception e) {
			e.printStackTrace();
			return null;
		}
	}
	
}
