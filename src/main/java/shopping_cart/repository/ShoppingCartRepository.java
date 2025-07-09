package shopping_cart.repository;

import java.util.List;

import org.apache.ibatis.annotations.Delete;
import org.apache.ibatis.annotations.Insert;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;
import org.apache.ibatis.annotations.Select;

import shopping_cart.entity.ShoppingCart;

@Mapper
public interface ShoppingCartRepository {

	@Insert("INSERT INTO shopping_cart (id, created_at, quantity, book_id, account_id) VALUES (seq_cart_id.nextval, SYSDATE, #{quantity}, #{bookId}, #{accountId})")
	void addToCart(ShoppingCart cart);

	@Delete("DELETE FROM shopping_cart WHERE id = #{id}")
	void removeFromCart(Long id);

	@Select("SELECT * FROM shopping_cart WHERE account_id = #{accountId}")
	List<ShoppingCart> findByAccountId(Long accountId);

	@Select("SELECT COUNT(*) FROM shopping_cart WHERE book_id = #{bookId}")
	int countByBookId(Long bookId);
	
	@Select("SELECT COUNT(*) FROM shopping_cart WHERE account_id = #{accountId} AND book_id = #{bookId}")
	int countByAccountIdAndBookId(@Param("accountId") Long accountId, @Param("bookId") Long bookId);
}
