package domain.payment.admin.entity;

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
	private int id;              // 寃곗젣 PK
    private Date createdAt;      // 寃곗젣�씪
    private String userName;     // �쉶�썝 �씠由�
    private String userId;       // �쉶�썝 �븘�씠�뵒
    private int bookId;          // �룄�꽌 PK
    private String bookTitle;    // �룄�꽌紐�
    private String bookAuthor;   // ���옄
    private String bookPublisher;// 異쒗뙋�궗
    private String bookGenre;
    private int bookPrice;       // 媛�寃�
    private int quantity;		 // �닔�웾
}
