package domain.review.user.service;

import org.springframework.stereotype.Service;

import domain.review.user.dto.CreateReviewDto;
import domain.review.user.entity.Review;
import domain.review.user.repository.ReviewRepository;
import global.exception.ApiException;
import lombok.RequiredArgsConstructor;

@Service
@RequiredArgsConstructor
public class ReviewService {
	private final ReviewRepository reviewRepository;

	public void insertReview(Long accountId, CreateReviewDto createReviewDto) {
		Review createReview = Review.builder().accountId(accountId).bookId(createReviewDto.getBookId()).contents(createReviewDto.getContent())
				.ratings(createReviewDto.getRatings()).build();
		int result = reviewRepository.save(createReview);
		if(result!=1) {
			throw new ApiException("리뷰 생성 실패");
		}

	}
}
