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
	
	@Select({
	    "<script>",
	    "SELECT id, title, author, publisher, image, price, published_at AS publishedAt, genre, page, introduction FROM book",
	    "WHERE",
	    "<choose>",
	        "<when test='field == \"title\"'> LOWER(title) LIKE LOWER('%' || #{keyword} || '%') </when>",
	        "<when test='field == \"author\"'> LOWER(author) LIKE LOWER('%' || #{keyword} || '%') </when>",
	        "<when test='field == \"publisher\"'> LOWER(publisher) LIKE LOWER('%' || #{keyword} || '%') </when>",
	    "</choose>",
	    "</script>"
	})
	List<Book> searchByField(@Param("field") String field, @Param("keyword") String keyword);
}
