package domain.payment.admin.dto;

import lombok.Data;

@Data
public class PaymentRank {
    private String name;     // 도서명 or 회원이름
    private int totalPrice;  // 총 결제 금액
    private int count;       // 결제 횟수
}