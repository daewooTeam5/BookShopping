package book.user.service;

import java.util.ArrayList;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import book.user.dao.BookDao;
import book.user.dto.Book;
import book.user.dto.PageList;



@Service
public class BookService {

	@Autowired
	BookDao dao;
	
	public Book detail(Long id) {
		return dao.findById(id);
	}
	
	public PageList getPageList(int requestPage, String field, String keyword) {
	    try {
	        boolean isSearch = keyword != null && !keyword.trim().isEmpty();

	        int totalCount = isSearch ? dao.countBySearch(field, keyword) : dao.count();
	        PageList pageList = PageList.builder().totalCount(totalCount).pagePerCount(10).build();

	        int totalPage = (totalCount % 10 == 0) ? (totalCount / 10) : (totalCount / 10 + 1);
	        pageList.setTotalPage(totalPage);
	        pageList.setCurrentPage(requestPage);

	        int startnum = ((requestPage - 1) * pageList.getPagePerCount()) + 1;
	        int endnum = requestPage * pageList.getPagePerCount();

	        int startPage = ((requestPage - 1) / 5 * 5) + 1;
	        int endPage = Math.min(startPage + 4, totalPage);

	        pageList.setStartPage(startPage);
	        pageList.setEndPage(endPage);
	        pageList.setPre(requestPage > 5);
	        pageList.setNext(endPage < totalPage);

	        List<Book> list = isSearch
	            ? dao.searchByField(field, keyword, startnum, endnum)
	            : dao.findAll(startnum, endnum);

	        pageList.setList(list);
	        return pageList;
	    } catch (Exception e) {
	        e.printStackTrace();
	        return null;
	    }
	}

	
}
