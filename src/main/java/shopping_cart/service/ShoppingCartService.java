package shopping_cart.service;

import java.util.ArrayList;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import book.dao.BookDao;
import shopping_cart.dto.ShoppingCartDto;
import shopping_cart.entity.ShoppingCart;
import shopping_cart.repository.ShoppingCartRepository;


@Service
public class ShoppingCartService {

    @Autowired
    private ShoppingCartRepository shoppingCartRepository;
    @Autowired
    private BookDao bookDao;

    public void addToCart(ShoppingCart cart) {
        if (shoppingCartRepository.countByAccountIdAndBookId(cart.getAccountId(), cart.getBookId()) > 0) {
            throw new RuntimeException("이미 장바구니에 담긴 상품입니다.");
        }
        shoppingCartRepository.addToCart(cart);
    }

    public void removeFromCart(Long id) {
        shoppingCartRepository.removeFromCart(id);
    }

    public List<ShoppingCartDto> getAllShoppingCartbyUserId(Long userId) {
    	// TODO 유저 정보 검증 
    	// User user = userRepository.findById(userId).orElseThrow();
    	List<ShoppingCartDto> dto = new ArrayList<>();
        shoppingCartRepository.findByAccountId(userId).forEach(shoppingCart->{
        	dto.add(
        			ShoppingCartDto.builder()
        			.accountId(userId)
        			.bookInfo(bookDao.findById(shoppingCart.getId()))
        			.build()
        	);
        });
        return dto;
    }

    public int countByBookId(Long bookId) {
        return shoppingCartRepository.countByBookId(bookId);
    }
}
