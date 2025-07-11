// src/main/java/payment/service/PaymentService.java
package payment.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import payment.dto.Payment;
import payment.mapper.PaymentMapper;
import shopping_cart.entity.ShoppingCart;
import shopping_cart.repository.ShoppingCartRepository;

@Service
public class PaymentService {

    @Autowired
    private PaymentMapper paymentMapper;

    @Autowired
    private ShoppingCartRepository shoppingCartRepository;

    
    public boolean processSinglePurchase(Long accountId, Long bookId) {
        Payment payment = Payment.builder()
                .accountId(accountId)
                .bookId(bookId)
                .build();
        
        return paymentMapper.insertPayment(payment) > 0;
    }

   
    @Transactional
    public boolean processCartPurchase(Long accountId) {
        // 1. 해당 유저의 장바구니 목록을 가져옵니다.
        List<ShoppingCart> cartItems = shoppingCartRepository.findByAccountId(accountId);

        if (cartItems.isEmpty()) {
            // 장바구니가 비어있으면 처리하지 않음
            return false;
        }

        // 2. 장바구니의 각 상품에 대해 결제 내역을 생성합니다.
        for (ShoppingCart item : cartItems) {
            Payment payment = Payment.builder()
                    .accountId(accountId)
                    .bookId(item.getBookId())
                    .build();
            paymentMapper.insertPayment(payment);

            // 3. 결제가 완료된 상품을 장바구니에서 삭제합니다.
            shoppingCartRepository.removeFromCart(item.getId());
        }

        return true;
    }
}