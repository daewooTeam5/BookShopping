package shopping_cart.controller;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.Authentication;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import shopping_cart.dto.ShoppingCartDto;
import shopping_cart.entity.ShoppingCart;
import shopping_cart.service.ShoppingCartService;

@Controller
@RequestMapping("/cart")
public class ShoppingCartController {

	@Autowired
	private ShoppingCartService shoppingCartService;

	@PostMapping
	public String addToCart(Authentication auth,ShoppingCart cart) {
		
		shoppingCartService.addToCart(cart,auth.getName());
		return "redirect:/book/list";
	}

	@PostMapping("delete/{id}")
	public void removeFromCart(@PathVariable Long id) {
		shoppingCartService.removeFromCart(id);
	}

	@GetMapping(value = "my/{id}", produces = "text/plain;charset=UTF-8")
	@ResponseBody
	public String getCartItems(@PathVariable(name = "id") Long userId) {
	    List<ShoppingCartDto> a = shoppingCartService.getAllShoppingCartbyUserId(userId);
	    System.out.println(a);
	    return a.toString();
	}

}
