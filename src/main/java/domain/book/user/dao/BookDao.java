package domain.book.user.dao;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;
import org.apache.ibatis.annotations.Select;

import domain.book.user.dto.Book;

@Mapper
public interface BookDao {
	
	@Select("SELECT * FROM ( " +
	        "SELECT ROWNUM AS rid, t1.* FROM ( " +
	        "SELECT * FROM book ORDER BY id DESC " +
	        ") t1 WHERE ROWNUM <= #{endnum} " +
	        ") WHERE rid >= #{startnum}")
	List<Book> findAll(@Param("startnum") int startnum, @Param("endnum") int endnum);
	
	@Select("select * from book where id=#{id}")
	public Book findById(Long id);
	
	@Select("select count(*) count from book")
	public int count();
	
	@Select({
	    "<script>",
	    "SELECT * FROM (",
	    "  SELECT ROWNUM AS rid, t.* FROM (",
	    "    SELECT * FROM book",
	    "    <where>",
	    "      <choose>",
	    "        <when test='field == &quot;title&quot;'> LOWER(title) LIKE LOWER('%' || #{keyword} || '%') </when>",
	    "        <when test='field == &quot;author&quot;'> LOWER(author) LIKE LOWER('%' || #{keyword} || '%') </when>",
	    "        <when test='field == &quot;publisher&quot;'> LOWER(publisher) LIKE LOWER('%' || #{keyword} || '%') </when>",
	    "      </choose>",
	    "    </where>",
	    "    ORDER BY id DESC",
	    "  ) t WHERE ROWNUM &lt;= #{endnum}",
	    ") WHERE rid &gt;= #{startnum}",
	    "</script>"
	})
	List<Book> searchByField(
	    @Param("field") String field,
	    @Param("keyword") String keyword,
	    @Param("startnum") int startnum,
	    @Param("endnum") int endnum
	);

	@Select({
	    "<script>",
	    "SELECT COUNT(*) FROM book",
	    "<where>",
	    "  <choose>",
	    "    <when test='field == \"title\"'> LOWER(title) LIKE LOWER('%' || #{keyword} || '%') </when>",
	    "    <when test='field == \"author\"'> LOWER(author) LIKE LOWER('%' || #{keyword} || '%') </when>",
	    "    <when test='field == \"publisher\"'> LOWER(publisher) LIKE LOWER('%' || #{keyword} || '%') </when>",
	    "  </choose>",
	    "</where>",
	    "</script>"
	})
	int countBySearch(
	    @Param("field") String field,
	    @Param("keyword") String keyword
	);

}

