package domain.book.user.service;

import java.util.ArrayList;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import domain.book.user.dao.BookDao;
import domain.book.user.dto.Book;
import domain.book.user.dto.PageList;
import domain.book.user.dto.GenreCount;



@Service
public class BookService {

	@Autowired
	BookDao dao;
	
	public Book detail(Long id) {
		return dao.findById(id);
	}
	
	public List<GenreCount> getGenreCounts() {
	    return dao.findGenreCounts();
	}

	
	public PageList getPageList(int requestPage, String field, String keyword, String genre) {
	    try {
	        boolean isSearch = keyword != null && !keyword.trim().isEmpty();
	        boolean isGenre = genre != null && !genre.trim().isEmpty();

	        int totalCount;
	        List<Book> list;
	        int startnum = ((requestPage - 1) * 10) + 1;
	        int endnum = requestPage * 10;

	        if (isGenre) {
	            totalCount = dao.countByGenre(genre);
	            list = dao.findByGenre(genre, startnum, endnum);
	        } else if (isSearch) {
	            totalCount = dao.countBySearch(field, keyword);
	            list = dao.searchByField(field, keyword, startnum, endnum);
	        } else {
	            totalCount = dao.count();
	            list = dao.findAll(startnum, endnum);
	        }

	        PageList pageList = PageList.builder().totalCount(totalCount).pagePerCount(10).build();
	        pageList.setCurrentPage(requestPage);
	        int totalPage = (totalCount + 9) / 10;
	        pageList.setTotalPage(totalPage);

	        int startPage = ((requestPage - 1) / 5 * 5) + 1;
	        int endPage = Math.min(startPage + 4, totalPage);
	        pageList.setStartPage(startPage);
	        pageList.setEndPage(endPage);
	        pageList.setPre(requestPage > 5);
	        pageList.setNext(endPage < totalPage);
	        pageList.setList(list);

	        return pageList;
	    } catch (Exception e) {
	        e.printStackTrace();
	        return null;
	    }
	}


	
}
