package domain.review.service;

import org.springframework.stereotype.Service;

import domain.review.dto.CreateReviewDto;
import domain.review.entity.Review;
import domain.review.repository.ReviewRepository;
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
