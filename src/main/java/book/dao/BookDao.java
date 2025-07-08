package book.dao;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Select;

import book.dto.Book;


@Mapper
public interface BookDao {
	
	@Select("select * from book")
	public List<Book> findAll();
	
	@Select("select * from book where id=#{id}")
	public Book findById(int id);
}
