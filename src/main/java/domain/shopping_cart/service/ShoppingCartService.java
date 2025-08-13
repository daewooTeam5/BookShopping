package domain.shopping_cart.service;

import java.util.ArrayList;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import domain.book.user.repository.BookRepository;
import domain.shopping_cart.dto.ShoppingCartDto;
import domain.shopping_cart.dto.ShoppingCartUserDto;
import domain.shopping_cart.entity.ShoppingCart;
import domain.shopping_cart.repository.ShoppingCartRepository;
import domain.user.repository.UserRepository;
import global.exception.ApiException;
import lombok.RequiredArgsConstructor;


@Service
@RequiredArgsConstructor
public class ShoppingCartService {
    private final ShoppingCartRepository shoppingCartRepository;
    private final BookRepository bookDao;
    private final UserRepository userMapper;

    public void addToCart(ShoppingCart cart,String authName) {
    	Long accountId = (authName != null) ? userMapper.getUserId(authName) : null;
    	System.out.println("autn"+authName+" id"+accountId);
    	if(bookDao.findById(cart.getBookId())==null) {
            throw new ApiException("존재 하지 않는 책입니다.");
    	}
        if (shoppingCartRepository.countByAccountIdAndBookId(accountId, cart.getBookId()) > 0) {
            throw new ApiException("이미 추가된 상품입니다.");
        }
        cart.setAccountId(accountId);
        shoppingCartRepository.addToCart(cart);
    }

    public void removeFromCart(Long id) {
        shoppingCartRepository.removeFromCart(id);
    }
    public List<ShoppingCartUserDto> getAllShoppCartJoinByUserId(String userId){
    	return shoppingCartRepository.findAllByShoppingCartJoinUser(userId);
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

    public void updateQuantity(Long id, int quantity) {
        shoppingCartRepository.updateQuantity(id, quantity);
    }
}
