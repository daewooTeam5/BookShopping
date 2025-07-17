// src/main/java/payment/dto/Payment.java
package domain.payment.user.dto;

import java.util.Date;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;


@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class Payment {
    private Long id;         // 결제 ID
    private Date createdAt;  // 결제일
    private Long accountId;  // 구매자 ID
    private Long bookId;     // 구매한 책 ID
}