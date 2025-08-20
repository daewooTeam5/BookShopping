package domain.review.user.entity;


import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Getter
@Setter
@Builder
@AllArgsConstructor
@NoArgsConstructor
public class Review {
	private Long id;
	private Long accountId;
	private Long bookId;
	private String contents;
	private Byte ratings;

}
