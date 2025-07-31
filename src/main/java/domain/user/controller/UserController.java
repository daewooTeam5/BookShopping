package domain.user.controller;

import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

import org.springframework.security.core.Authentication;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;

import domain.payment.user.dto.PaymentDetailDto;
import domain.payment.user.service.PaymentService;
import domain.shopping_cart.dto.ShoppingCartUserDto;
import domain.shopping_cart.service.ShoppingCartService;
import domain.user.dto.UserRegisterForm;
import domain.user.entity.UserEntity;
import domain.user.service.UserService;
import lombok.RequiredArgsConstructor;

@Controller
@RequiredArgsConstructor
public class UserController {
	private final UserService userService;
	private final ShoppingCartService shoppingCartService;
	private final PaymentService paymentSerivce;

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
		List<PaymentDetailDto> paymentList = paymentSerivce.getPaymentDetailsByAccountId(user.getId());
		Map<String, List<PaymentDetailDto>> groupedPayments = paymentList.stream().collect(
				Collectors.groupingBy(PaymentDetailDto::getReceiptId, LinkedHashMap::new, Collectors.toList()));
		model.addAttribute("groupedPayments", groupedPayments);
		System.out.println(shoppingCart);
		model.addAttribute("user", user);
		model.addAttribute("shoppingCart", shoppingCart);
		model.addAttribute("myPaymentList", paymentList);
		Integer totalPaymentAmount = paymentSerivce.getTotalPaymentAmountByAccountId(user.getId());
		model.addAttribute("totalPaymentAmount", totalPaymentAmount);
		System.out.println(paymentList);
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
		System.out.println(user);
		userService.registerUser(user);
		return "redirect:/login";
	}
}
