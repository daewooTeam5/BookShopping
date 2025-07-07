package shopping_cart.controller;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.bind.annotation.RestController;

import shopping_cart.entity.ShoppingCart;
import shopping_cart.service.ShoppingCartService;

@RestController
@RequestMapping("/cart")
public class ShoppingCartController {

    @Autowired
    private ShoppingCartService shoppingCartService;

    @PostMapping
    public void addToCart( ShoppingCart cart) {
        shoppingCartService.addToCart(cart);
    }

    @PostMapping("delete/{id}")
    public void removeFromCart(@PathVariable Long id) {
        shoppingCartService.removeFromCart(id);
    }

    @GetMapping("my/{accountId}")
    @ResponseBody
    public  String getCartItems(@PathVariable Long accountId) {
        List<ShoppingCart> a = shoppingCartService.findByAccountId(accountId);
        System.out.println(a);
        return a.toString();
    }
}

