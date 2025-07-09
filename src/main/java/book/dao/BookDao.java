package book.dao;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;
import org.apache.ibatis.annotations.Select;

import book.dto.Book;


@Mapper
public interface BookDao {
	
	@Select("SELECT * FROM ( " +
	        "SELECT ROWNUM AS rid, t1.* FROM ( " +
	        "SELECT * FROM book ORDER BY id DESC " +
	        ") t1 WHERE ROWNUM <= #{endnum} " +
	        ") WHERE rid >= #{startnum}")
	List<Book> findAll(@Param("startnum") int startnum, @Param("endnum") int endnum);
	
	@Select("select * from book where id=#{id}")
	public Book findById(int id);
	
	@Select("select count(*) count from book")
	public int count();
}

