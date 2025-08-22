package domain.review.user.entity;

import java.util.Date;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import lombok.ToString;

@Getter
@Setter
@Builder
@AllArgsConstructor
@NoArgsConstructor
@ToString
public class ReviewUserDto {
	private Long id;
	private Date createdAt;
	private String writerName;
	private Long writerId;
	private String contents;
	private Byte ratings;
}
