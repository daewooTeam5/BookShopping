package domain.shopping_cart.controller;

import com.fasterxml.jackson.core.type.TypeReference;
import com.fasterxml.jackson.databind.ObjectMapper;
import domain.shopping_cart.dto.ShoppingCartDto;
import domain.shopping_cart.dto.ShoppingCartUserDto;
import domain.shopping_cart.entity.ShoppingCart;
import domain.shopping_cart.service.ShoppingCartService;
import java.net.URLDecoder;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.Authentication;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

@Controller
@RequestMapping("/cart")
public class ShoppingCartController {

	@Autowired
	private ShoppingCartService shoppingCartService;

	@Data
	@NoArgsConstructor
	@AllArgsConstructor
	public static class CartItemCookie {
		private Long bookId;
		private Date createdAt;
		private Integer quantity;
	}

	@PostMapping
	public String addToCart(Authentication auth, ShoppingCart cart, HttpServletRequest request,
			HttpServletResponse response) {
		if (auth == null) {
			try {
				ObjectMapper objectMapper = new ObjectMapper();
				List<CartItemCookie> cartItems = new ArrayList<>();
				Cookie[] cookies = request.getCookies();
				if (cookies != null) {
					for (Cookie cookie : cookies) {
						if (cookie.getName().equals("cart")) {
							String decodedCart = URLDecoder.decode(cookie.getValue(), StandardCharsets.UTF_8.name());
							cartItems = objectMapper.readValue(decodedCart,
									new TypeReference<List<CartItemCookie>>() {
									});
							break;
						}
					}
				}
				CartItemCookie newCartItem = new CartItemCookie(cart.getBookId(), new Date(), cart.getQuantity());
				cartItems.add(newCartItem);
				String cartJson = objectMapper.writeValueAsString(cartItems);
				String encodedCart = URLEncoder.encode(cartJson, StandardCharsets.UTF_8.name());
				Cookie cartCookie = new Cookie("cart", encodedCart);
				cartCookie.setPath("/");
				cartCookie.setMaxAge(60 * 60 * 24 * 7); // 7 days
				cartCookie.setHttpOnly(false);
				cartCookie.setSecure(false);
				response.addCookie(cartCookie);
			} catch (Exception e) {
				e.printStackTrace();
			}
			return "redirect:/book/list";
		}

		shoppingCartService.addToCart(cart, auth.getName());

		return "redirect:/book/list";
	}

	@GetMapping("/api/my-cart")
	@ResponseBody
	public List<ShoppingCartUserDto> getMyCart(Authentication auth) {
		if (auth == null) {
			return new ArrayList<>();
		}
		String userId = auth.getName();
		return shoppingCartService.getAllShoppCartJoinByUserId(userId);
	}

	@PostMapping("delete/{id}")
	@ResponseBody
	public java.util.Map<String, Object> removeFromCart(@PathVariable Long id) {
		java.util.Map<String, Object> response = new java.util.HashMap<>();
		try {
			shoppingCartService.removeFromCart(id);
			response.put("success", true);
		} catch (Exception e) {
			response.put("success", false);
			response.put("message", e.getMessage());
		}
		return response;
	}

	@GetMapping(value = "my/{id}", produces = "text/plain;charset=UTF-8")
	@ResponseBody
	public String getCartItems(@PathVariable(name = "id") Long userId) {
	    List<ShoppingCartDto> a = shoppingCartService.getAllShoppingCartbyUserId(userId);
	    System.out.println(a);
	    return a.toString();
	}

    @PostMapping("/update-quantity")
    @ResponseBody
    public java.util.Map<String, Object> updateQuantity(@RequestParam("id") Long id, @RequestParam("quantity") int quantity) {
        shoppingCartService.updateQuantity(id, quantity);
        java.util.Map<String, Object> response = new java.util.HashMap<>();
        response.put("success", true);
        response.put("newQuantity", quantity);
        return response;
    }
}