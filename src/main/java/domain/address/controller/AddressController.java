package domain.address.controller;

import domain.address.entity.Address;
import domain.address.service.AddressService;
import domain.user.repository.UserRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.security.core.Authentication;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller
@RequestMapping("/address")
@RequiredArgsConstructor
public class AddressController {

    private final AddressService addressService;
    private final UserRepository userRepository;

    @PostMapping("/add")
    public String addAddress(Address address, Authentication authentication) {
        // 현재 로그인한 사용자의 ID를 조회합니다.
        String currentUserId = authentication.getName();
        Long accountId = userRepository.getUserId(currentUserId);
        
        // 주소 객체에 사용자 ID를 설정합니다.
        address.setAccountId(accountId);
        
        // 주소를 저장합니다.
        addressService.addAddress(address);
        
        // 주소 추가 후 마이페이지로 리다이렉트합니다.
        return "redirect:/user/my-page";
    }
}
