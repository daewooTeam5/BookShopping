package book.admin;

import java.util.List;

import org.apache.ibatis.annotations.Delete;
import org.apache.ibatis.annotations.Insert;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;
import org.apache.ibatis.annotations.Select;
import org.apache.ibatis.annotations.Update;

@Mapper
public interface BookAdminMapper {
	@Select("SELECT id, title, author, publisher, image, price, published_at AS publishedAt, genre, page, introduction FROM book")
	List<Book> findAll();
}
