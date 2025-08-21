package domain.book.user.repository;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;
import org.apache.ibatis.annotations.Select;

import domain.book.user.dto.Book;
import domain.book.user.dto.GenreCount;

@Mapper
public interface BookRepository {
    
    @Select("SELECT * FROM ( " +
            "SELECT ROWNUM AS rid, t1.* FROM ( " +
            "SELECT * FROM book WHERE is_deleted = 'N' ORDER BY id DESC " +
            ") t1 WHERE ROWNUM <= #{endnum} " +
            ") WHERE rid >= #{startnum}")
    List<Book> findAll(@Param("startnum") int startnum, @Param("endnum") int endnum);
    
    @Select("SELECT * FROM book WHERE id = #{id} AND is_deleted = 'N'")
    public Book findById(Long id);
    
    @Select("SELECT COUNT(*) FROM book WHERE is_deleted = 'N'")
    public int count();
    
    @Select({
        "<script>",
        "SELECT * FROM (",
        "  SELECT ROWNUM AS rid, t.* FROM (",
        "    SELECT * FROM book",
        "    <where>",
        "      is_deleted = 'N'",
        "      <choose>",
        "        <when test='field == &quot;title&quot;'> AND LOWER(title) LIKE LOWER('%' || #{keyword} || '%') </when>",
        "        <when test='field == &quot;author&quot;'> AND LOWER(author) LIKE LOWER('%' || #{keyword} || '%') </when>",
        "        <when test='field == &quot;publisher&quot;'> AND LOWER(publisher) LIKE LOWER('%' || #{keyword} || '%') </when>",
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
        "  is_deleted = 'N'",
        "  <choose>",
        "    <when test='field == \"title\"'> AND LOWER(title) LIKE LOWER('%' || #{keyword} || '%') </when>",
        "    <when test='field == \"author\"'> AND LOWER(author) LIKE LOWER('%' || #{keyword} || '%') </when>",
        "    <when test='field == \"publisher\"'> AND LOWER(publisher) LIKE LOWER('%' || #{keyword} || '%') </when>",
        "  </choose>",
        "</where>",
        "</script>"
    })
    int countBySearch(
        @Param("field") String field,
        @Param("keyword") String keyword
    );
    
    @Select("SELECT genre, COUNT(*) AS count FROM book WHERE is_deleted = 'N' GROUP BY genre ORDER BY genre")
    List<GenreCount> findGenreCounts();
    
    @Select("SELECT * FROM (SELECT ROWNUM AS rid, t.* FROM (SELECT * FROM book WHERE genre = #{genre} AND is_deleted = 'N' ORDER BY id DESC) t WHERE ROWNUM <= #{endnum}) WHERE rid >= #{startnum}")
    List<Book> findByGenre(@Param("genre") String genre, @Param("startnum") int startnum, @Param("endnum") int endnum);

    @Select("SELECT COUNT(*) FROM book WHERE genre = #{genre} AND is_deleted = 'N'")
    int countByGenre(@Param("genre") String genre);

    @Select("SELECT b.id AS id, b.title AS title, b.author AS author, b.publisher AS publisher, b.price AS price, b.image AS image, " +
            "NVL(AVG(r.ratings), 0) AS avgRating, " +
            "COUNT(DISTINCT r.id) AS reviewCount, " +
            "NVL(SUM(p.quantity), 0) AS salesCount, " +
            "(NVL(AVG(r.ratings), 0) * 0.5 + " +
            " COUNT(DISTINCT r.id) * 0.2 + " +
            " NVL(SUM(p.quantity), 0) * 0.3) AS score " +
            "FROM book b " +
            "LEFT JOIN review r ON b.id = r.book_id " +
            "LEFT JOIN payment p ON b.id = p.book_id " +
            "WHERE b.is_deleted = 'N' " +
            "GROUP BY b.id, b.title, b.author, b.publisher, b.price, b.image " +
            "ORDER BY score DESC " +
            "FETCH FIRST 10 ROWS ONLY")
    List<Book> findPopularBooks();

    @Select("SELECT b.id AS id, b.title AS title, b.author AS author, b.publisher AS publisher, b.price AS price, b.image AS image, " +
            "NVL(SUM(p.quantity), 0) AS salesCount " +
            "FROM book b " +
            "LEFT JOIN payment p ON b.id = p.book_id " +
            "WHERE b.is_deleted = 'N' " +
            "GROUP BY b.id, b.title, b.author, b.publisher, b.price, b.image " +
            "ORDER BY salesCount DESC " +
            "FETCH FIRST 10 ROWS ONLY")
    List<Book> findBestSellerBooks();

    @Select("SELECT * FROM (SELECT * FROM book WHERE is_deleted = 'N' ORDER BY DBMS_RANDOM.VALUE) WHERE ROWNUM <= 5")
    List<Book> findRandomBooks();
}
