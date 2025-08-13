package domain.user.controller;

import domain.address.entity.Address;
import domain.address.service.AddressService;
import domain.payment.user.dto.PaymentDetailDto;
import domain.payment.user.service.PaymentService;
import domain.shopping_cart.dto.ShoppingCartUserDto;
import domain.shopping_cart.service.ShoppingCartService;
import domain.user.dto.UserRegisterForm;
import domain.user.entity.UserEntity;
import domain.user.service.UserService;
import lombok.RequiredArgsConstructor;
import org.springframework.security.core.Authentication;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;

import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

@Controller
@RequiredArgsConstructor
public class UserController {
    private final UserService userService;
    private final ShoppingCartService shoppingCartService;
    private final PaymentService paymentService;
    private final AddressService addressService; // AddressService 주입

    @GetMapping("/")
    public String mainPage() {
        return "redirect:/book/list";
    }

    @GetMapping("user/login")
    public String loginRedirect() {
        return "redirect:/login";
    }

    @GetMapping("/user/my-page")
    public String myPage(Authentication authentication, Model model) {
        String userId = authentication.getName();
        UserEntity user = userService.findByUserId(userId);
        List<ShoppingCartUserDto> shoppingCart = shoppingCartService.getAllShoppCartJoinByUserId(userId);
        List<PaymentDetailDto> paymentList = paymentService.getPaymentDetailsByAccountId(user.getId());
        
        // 사용자의 주소 목록 조회
        List<Address> addressList = addressService.getAddressesByAccountId(user.getId());
        model.addAttribute("addressList", addressList); // 모델에 주소 목록 추가

        Map<String, List<PaymentDetailDto>> groupedPayments = paymentList.stream().collect(
                Collectors.groupingBy(PaymentDetailDto::getReceiptId, LinkedHashMap::new, Collectors.toList()));
        
        model.addAttribute("groupedPayments", groupedPayments);
        model.addAttribute("user", user);
        model.addAttribute("shoppingCart", shoppingCart);
        model.addAttribute("myPaymentList", paymentList);
        Integer totalPaymentAmount = paymentService.getTotalPaymentAmountByAccountId(user.getId());
        model.addAttribute("totalPaymentAmount", totalPaymentAmount);
        return "user/mypage";
    }

    @GetMapping("/login")
    public String login() {
        return "user/login";
    }

    @GetMapping("/register")
    public String registerForm() {
        return "user/register";
    }

    @PostMapping("/register")
    public String register(UserRegisterForm user) {
        userService.registerUser(user);
        return "redirect:/login";
    }
}
