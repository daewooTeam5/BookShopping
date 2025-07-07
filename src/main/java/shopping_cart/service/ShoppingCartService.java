package shopping_cart.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import shopping_cart.entity.ShoppingCart;
import shopping_cart.repository.ShoppingCartRepository;

@Service
public class ShoppingCartService {

    @Autowired
    private ShoppingCartRepository shoppingCartRepository;

    public void addToCart(ShoppingCart cart) {
        shoppingCartRepository.addToCart(cart);
    }

    public void removeFromCart(Long id) {
        shoppingCartRepository.removeFromCart(id);
    }

    public List<ShoppingCart> findByAccountId(Long accountId) {
        return shoppingCartRepository.findByAccountId(accountId);
    }

    public int countByBookId(Long bookId) {
        return shoppingCartRepository.countByBookId(bookId);
    }
}
