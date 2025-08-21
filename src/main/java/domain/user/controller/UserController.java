package domain.user.controller;


import java.util.ArrayList;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.core.userdetails.User;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.web.context.HttpSessionSecurityContextRepository;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

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

@Controller
@RequiredArgsConstructor
public class UserController {
    private final UserService userService;
    private final ShoppingCartService shoppingCartService;

    @GetMapping("/guest")
    public String guestLogin(HttpServletRequest request) {
        // 1. 난수 아이디 생성
        String randomId = "user" + (int)(Math.random() * 100000);

        // 2. 비회원 정보 생성
        UserRegisterForm guestForm = new UserRegisterForm();
        guestForm.setUserId(randomId);
        guestForm.setPassword("{noop}1234"); // 비회원 패스워드 {noop} 처리+1234부여
        guestForm.setName("guest");
        guestForm.setUserRole("ROLE_GUEST");
        
        // 3. DB 저장
        userService.registerUser(guestForm); // 저장 후 ID 부여 3개

        // 4. UserDetails 생성 (ROLE_USER 권한)
        UserDetails guestUser = User.builder()
                .username(randomId)
                .password("{noop}1234")  //1234로 부여
                .roles("GUEST")  //임시 유저 권한부여
                .build();

        // 5. 인증 객체 생성 및 세션 저장
        Authentication auth = new UsernamePasswordAuthenticationToken(
                guestUser, null, guestUser.getAuthorities()
        );
        SecurityContextHolder.getContext().setAuthentication(auth);
        request.getSession().setAttribute(
                HttpSessionSecurityContextRepository.SPRING_SECURITY_CONTEXT_KEY,
                SecurityContextHolder.getContext()
        );

        return "redirect:/book/list";
    }
    
    @PostMapping("/register")
    public String register(UserRegisterForm user) {
    	System.out.println(user);
        userService.registerUser(user);
        return "redirect:/login"; 
    }
    
    @PostMapping("/user/receipt")
    public String receipt(
            @RequestParam String receiptId,
            @RequestParam String createdAt,
            @RequestParam String title,
            @RequestParam String image,
            @RequestParam String genre,
            @RequestParam String publisher,
            @RequestParam int price,
            @RequestParam int quantity,
            Model model) {

        model.addAttribute("receiptId", receiptId);
        model.addAttribute("createdAt", createdAt);
        model.addAttribute("title", title);
        model.addAttribute("image", image);
        model.addAttribute("genre", genre);
        model.addAttribute("publisher", publisher);
        model.addAttribute("price", price);
        model.addAttribute("quantity", quantity);

        return "user/receipt";
    }


    private final PaymentService paymentService;
    private final AddressService addressService; // AddressService 주입

    @GetMapping("/")
    public String mainPage() {
        return "redirect:/book/main";
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

        Map<String, List<PaymentDetailDto>> groupedPayments = new LinkedHashMap<>();

        for (PaymentDetailDto payment : paymentList) {
        	System.out.println(payment);
            String receiptId = payment.getReceiptId();
            
            // 맵에 키가 없으면 새 리스트 생성
            if (!groupedPayments.containsKey(receiptId)) {
                groupedPayments.put(receiptId, new ArrayList<>());
            }
            
            // 해당 리스트에 현재 payment 추가
            groupedPayments.get(receiptId).add(payment);
        }
        System.out.println("groupdafdas"+groupedPayments);
        model.addAttribute("groupedPayments", groupedPayments);
        model.addAttribute("user", user);
        model.addAttribute("shoppingCart", shoppingCart);
        model.addAttribute("myPaymentList", paymentList);
        Integer totalPaymentAmount = paymentService.getTotalPaymentAmountByAccountId(user.getId());
        Integer totalQuantity = paymentService.getTotalQuantityByAccountId(user.getId());
        System.out.println(totalQuantity);
        model.addAttribute("totalPaymentAmount", totalPaymentAmount);
        model.addAttribute("totalQuantity", totalQuantity);
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

}
