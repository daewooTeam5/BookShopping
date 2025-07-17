package domain.shopping_cart.repository;

import java.util.List;

import org.apache.ibatis.annotations.Delete;
import org.apache.ibatis.annotations.Insert;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;
import org.apache.ibatis.annotations.Select;
import org.apache.ibatis.annotations.Update;

import domain.shopping_cart.dto.ShoppingCartUserDto;
import domain.shopping_cart.entity.ShoppingCart;

@Mapper
public interface ShoppingCartRepository {

	@Insert("INSERT INTO shopping_cart (id, created_at, quantity, book_id, account_id) VALUES (seq_cart_id.nextval, SYSDATE, #{quantity}, #{bookId}, #{accountId})")
	void addToCart(ShoppingCart cart);

	@Delete("DELETE FROM shopping_cart WHERE id = #{id}")
	void removeFromCart(Long id);

	@Select("SELECT * FROM shopping_cart WHERE account_id = #{accountId}")
	List<ShoppingCart> findByAccountId(Long accountId);

	@Select("SELECT sc.id ,b.title,b.author,b.publisher,b.image,b.price,b.genre,b.PUBLISHED_AT as publisedAt,b.page,b.introduction,sc.quantity "
			+ "FROM shopping_cart sc " + "JOIN  book b " + "ON b.ID = sc.BOOK_ID " + "JOIN account u "
			+ "ON u.ID = sc.ACCOUNT_ID " + "WHERE u.user_id =#{accountId}")
	List<ShoppingCartUserDto> findAllByShoppingCartJoinUser(String accountId);

	@Select("SELECT COUNT(*) FROM shopping_cart WHERE book_id = #{bookId}")
	int countByBookId(Long bookId);

	@Select("SELECT COUNT(*) FROM shopping_cart WHERE account_id = #{accountId} AND book_id = #{bookId}")
	int countByAccountIdAndBookId(@Param("accountId") Long accountId, @Param("bookId") Long bookId);

	@Update("UPDATE shopping_cart SET quantity = #{quantity} WHERE id = #{id}")
	void updateQuantity(@Param("id") Long id, @Param("quantity") int quantity);

	@Select({ "<script>",
			"SELECT id,created_at as createdAt,account_id as accountId,book_id as bookId,quantity FROM shopping_cart WHERE id IN ",
			"<foreach item='id' collection='list' open='(' separator=',' close=')'>", "#{id}", "</foreach>",
			"</script>" })
	List<ShoppingCart> findByIds(List<Long> ids);
}
