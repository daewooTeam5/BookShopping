package domain.payment.admin;

import java.util.Date;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import lombok.ToString;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@ToString
public class PaymentAdmin {
	private int id;              // 결제 PK
    private Date createdAt;      // 결제일
    private String userName;     // 회원 이름
    private String userId;       // 회원 아이디
    private int bookId;          // 도서 PK
    private String bookTitle;    // 도서명
    private String bookAuthor;   // 저자
    private String bookPublisher;// 출판사
    private int bookPrice;       // 가격
    private int quantity;		 // 수량
}
