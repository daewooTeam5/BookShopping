package domain.book.admin.repository;

import java.util.List;

import org.apache.ibatis.annotations.Insert;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;
import org.apache.ibatis.annotations.Select;
import org.apache.ibatis.annotations.Update;

import domain.book.admin.entity.Book;

@Mapper
public interface BookAdminRepository {

    @Select("SELECT id, title, author, publisher, image, price, published_at AS publishedAt, genre, page, introduction, is_deleted AS isDeleted " +
            "FROM book WHERE is_deleted = 'N' and rownum <100")
    List<Book> findAll();

    @Select("SELECT id, title, author, publisher, image, price, published_at AS publishedAt, genre, page, introduction, is_deleted AS isDeleted FROM book where rownum<200")
    List<Book> findAllWithDeleted();

    @Select({
        "<script>",
        "SELECT id, title, author, publisher, image, price, published_at AS publishedAt, genre, page, introduction, is_deleted AS isDeleted",
        "FROM book",
        "WHERE is_deleted = 'N' AND",
        "<choose>",
            "<when test='field == \"title\"'> LOWER(title) LIKE LOWER('%' || #{keyword} || '%') </when>",
            "<when test='field == \"author\"'> LOWER(author) LIKE LOWER('%' || #{keyword} || '%') </when>",
            "<when test='field == \"publisher\"'> LOWER(publisher) LIKE LOWER('%' || #{keyword} || '%') </when>",
        "</choose>",
        "</script>"
    })
    List<Book> searchByField(@Param("field") String field, @Param("keyword") String keyword);

    @Select({
        "<script>",
        "SELECT id, title, author, publisher, image, price, published_at AS publishedAt, genre, page, introduction, is_deleted AS isDeleted",
        "FROM book",
        "WHERE",
        "<choose>",
            "<when test='field == \"title\"'> LOWER(title) LIKE LOWER('%' || #{keyword} || '%') </when>",
            "<when test='field == \"author\"'> LOWER(author) LIKE LOWER('%' || #{keyword} || '%') </when>",
            "<when test='field == \"publisher\"'> LOWER(publisher) LIKE LOWER('%' || #{keyword} || '%') </when>",
        "</choose>",
        "</script>"
    })
    List<Book> searchByFieldWithDeleted(@Param("field") String field, @Param("keyword") String keyword);

    @Insert(
        "INSERT INTO book (" +
        "title, author, publisher, image, price, published_at, genre, page, introduction, is_deleted" +
        ") VALUES (" +
        "#{title}, #{author}, #{publisher}, #{image}, #{price}, #{publishedAt}, " +
        "#{genre}, #{page}, #{introduction}, 'N'" +
        ")"
    )
    int save(Book book);

    @Select("SELECT id, title, author, publisher, image, price, published_at AS publishedAt, genre, page, introduction, is_deleted AS isDeleted " +
            "FROM book WHERE id = #{id} AND is_deleted = 'N'")
    Book findById(@Param("id") int id);

    @Select("SELECT id, title, author, publisher, image, price, published_at AS publishedAt, genre, page, introduction, is_deleted AS isDeleted FROM book WHERE id = #{id}")
    Book findAnyById(@Param("id") int id);

    @Update("UPDATE book " +
            "SET title = #{title}, " +
            "author = #{author}, " +
            "publisher = #{publisher}, " +
            "price = #{price}, " +
            "published_at = #{publishedAt}, " +
            "genre = #{genre}, " +
            "page = #{page}, " +
            "image = #{image}, " +
            "introduction = #{introduction, jdbcType=VARCHAR} " +
            "WHERE id = #{id} AND is_deleted = 'N'")
    int update(Book book);

    @Update("UPDATE book SET is_deleted = 'Y' WHERE id = #{id}")
    int delete(@Param("id") int id);

    @Update("UPDATE book SET is_deleted = 'N' WHERE id = #{id}")
    int restore(@Param("id") int id);

    @Select("SELECT COUNT(*) FROM book WHERE is_deleted = 'N'")
    int countAll();

    @Select(
        "SELECT * FROM (" +
        "  SELECT b.id, b.title, b.author, b.publisher, b.image, b.price, " +
        "         b.published_at AS publishedAt, b.genre, b.page, b.introduction, b.is_deleted AS isDeleted, " +
        "         ROW_NUMBER() OVER (ORDER BY b.id DESC) AS rn " +
        "  FROM book b " +
        "  WHERE b.is_deleted = 'N'" +
        ") " +
        "WHERE rn BETWEEN #{startRow} AND #{endRow}"
    )
    List<Book> findPage(@Param("startRow") int startRow, @Param("endRow") int endRow);
}
