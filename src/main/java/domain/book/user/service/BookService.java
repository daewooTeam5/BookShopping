package domain.book.user.service;

import java.util.Arrays;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.converter.json.MappingJackson2HttpMessageConverter;
import org.springframework.stereotype.Service;
import org.springframework.web.client.ResourceAccessException;
import org.springframework.web.client.RestTemplate;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.databind.SerializationFeature;
import com.fasterxml.jackson.datatype.jsr310.JavaTimeModule;

import domain.book.user.dto.Book;
import domain.book.user.dto.GenreCount;
import domain.book.user.dto.PageList;
import domain.book.user.repository.BookRepository;

@Service
public class BookService {
	@Autowired
	RestTemplate restTemplate;

	@Autowired
	BookRepository dao;

	public Book detail(Long id) {
		return dao.findById(id);
	}

	public List<GenreCount> getGenreCounts() {
		return dao.findGenreCounts();
	}

	public List<Book> getPopularBooks() {
		return dao.findPopularBooks();
	}

	public List<Book> getBestSellers() {
		return dao.findBestSellerBooks();
	}

	public List<Book> getRandomBooks() {
		return dao.findRandomBooks();
	}

	public List<Book> getRecommandBook(Long currentId) {
		try {

			System.out.println("call python api ");
			String url = "http://127.0.0.1:8848/recommend_by_id?book_id=" + currentId + "&top_n=5";
			ObjectMapper mapper = new ObjectMapper();
			mapper.registerModule(new JavaTimeModule());
			mapper.disable(SerializationFeature.WRITE_DATES_AS_TIMESTAMPS);

			restTemplate.getMessageConverters().add(0, new MappingJackson2HttpMessageConverter(mapper));

			// API 호출
			Book[] recommendedBooks = restTemplate.getForObject(url, Book[].class);
			System.out.println(recommendedBooks);

			return Arrays.asList(recommendedBooks);
		} catch (ResourceAccessException e) {
			System.out.println(e);
			return getRandomBooks();
		}
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
