package domain.payment.user.dto;

import java.util.Date;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

/**
 * 결제 정보를 담는 DTO 클래스입니다.
 * (주석: 기존의 address(String) 필드를 addressId(Long)으로 변경하여, 
 * 'address' 테이블의 특정 주소(ID)를 참조하도록 수정했습니다.)
 */
@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class Payment {

    private Long id;            // 결제 ID (PK)
    private Date createdAt;     // 결제일
    private Long accountId;     // 구매자 ID (FK)
    private Long bookId;        // 구매한 책 ID (FK)
    private int quantity;       // 수량
    private String receiptId;   // 영수증 번호 (거래 식별용)
    private Long addressId;     // 배송지 주소 ID (FK, address 테이블 참조)
}

