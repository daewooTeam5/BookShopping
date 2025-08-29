package global.security;

import com.fasterxml.jackson.core.type.TypeReference;
import com.fasterxml.jackson.databind.ObjectMapper;
import domain.shopping_cart.controller.ShoppingCartController.CartItemCookie;
import domain.shopping_cart.entity.ShoppingCart;
import domain.shopping_cart.service.ShoppingCartService;
import java.io.IOException;
import java.net.URLDecoder;
import java.nio.charset.StandardCharsets;
import java.util.List;
import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.web.authentication.AuthenticationSuccessHandler;
import org.springframework.stereotype.Component;
import org.springframework.web.util.WebUtils;

@Component
public class CustomAuthenticationSuccessHandler implements AuthenticationSuccessHandler {

    @Autowired
    private ShoppingCartService shoppingCartService;

    private ObjectMapper objectMapper = new ObjectMapper();

    @Override
    public void onAuthenticationSuccess(HttpServletRequest request, HttpServletResponse response,
                                        Authentication authentication) throws IOException {

        // 1. 쿠키의 장바구니를 DB로 옮기는 작업
        mergeCookieCartToDb(request, response, authentication);

        // 2. 기존의 역할 기반 리다이렉트 로직 수행
        String redirectUrl = "/book/list";
        for (GrantedAuthority auth : authentication.getAuthorities()) {
            if (auth.getAuthority().equals("ROLE_ADMIN")) {
                redirectUrl = "/book/admin/list";
                break;
            }
        }
        response.sendRedirect(redirectUrl);
    }

    private void mergeCookieCartToDb(HttpServletRequest request, HttpServletResponse response, Authentication authentication) {
        Cookie cartCookie = WebUtils.getCookie(request, "cart");

        if (cartCookie != null && cartCookie.getValue() != null && !cartCookie.getValue().isEmpty()) {
            try {
                String decodedValue = URLDecoder.decode(cartCookie.getValue(), StandardCharsets.UTF_8.name());
                List<CartItemCookie> cookieItems = objectMapper.readValue(decodedValue, new TypeReference<List<CartItemCookie>>() {});

                String username = authentication.getName();

                for (CartItemCookie item : cookieItems) {
                    ShoppingCart cart = new ShoppingCart();
                    cart.setBookId(item.getBookId());
                    cart.setQuantity(item.getQuantity());
                    // ShoppingCartService의 addToCart는 내부에 계정 ID를 사용하므로 사용자 이름만 넘겨줌
                    shoppingCartService.addToCart(cart, username);
                }

                // 쿠키 삭제
                cartCookie.setValue("");
                cartCookie.setPath("/");
                cartCookie.setMaxAge(0);
                response.addCookie(cartCookie);

            } catch (Exception e) {
                // 로깅 추가 (실제 프로덕션에서는 로거 사용)
                System.err.println("장바구니 쿠키 처리 중 오류 발생: " + e.getMessage());
            }
        }
    }
}
