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

    // 1. 전체 목록 (삭제X만)
    @Select("SELECT id, title, author, publisher, image, price, published_at AS publishedAt, genre, page, introduction, is_deleted AS isDeleted " +
            "FROM book WHERE is_deleted = 'N'")
    List<Book> findAll();

    // 2. 전체 목록 (삭제 포함, 관리자)
    @Select("SELECT id, title, author, publisher, image, price, published_at AS publishedAt, genre, page, introduction, is_deleted AS isDeleted FROM book")
    List<Book> findAllWithDeleted();

    // 3. 검색(삭제X만)
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

    // 4. 검색(삭제 포함, 관리자)
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

    // 5. 등록
    @Insert(
        "INSERT INTO book (" +
        "title, author, publisher, image, price, published_at, genre, page, introduction, is_deleted" +
        ") VALUES (" +
        "#{title}, #{author}, #{publisher}, #{image}, #{price}, #{publishedAt}, " +
        "#{genre}, #{page}, #{introduction}, 'N'" +
        ")"
    )
    int save(Book book);

    // 6. 단일 조회(삭제X만)
    @Select("SELECT id, title, author, publisher, image, price, published_at AS publishedAt, genre, page, introduction, is_deleted AS isDeleted " +
            "FROM book WHERE id = #{id} AND is_deleted = 'N'")
    Book findById(@Param("id") int id);

    // 7. 단일 조회(삭제 포함)
    @Select("SELECT id, title, author, publisher, image, price, published_at AS publishedAt, genre, page, introduction, is_deleted AS isDeleted FROM book WHERE id = #{id}")
    Book findAnyById(@Param("id") int id);

    // 8. 수정(삭제X만)
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

    // 9. 논리적 삭제
    @Update("UPDATE book SET is_deleted = 'Y' WHERE id = #{id}")
    int delete(@Param("id") int id);

    // 10. (선택) 논리적 삭제 복구
    @Update("UPDATE book SET is_deleted = 'N' WHERE id = #{id}")
    int restore(@Param("id") int id);
}
