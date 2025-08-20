package domain.review.user.controller;

import org.springframework.security.core.Authentication;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;

import domain.review.user.dto.CreateReviewDto;
import domain.review.user.service.ReviewService;
import domain.user.entity.UserEntity;
import domain.user.service.UserService;
import global.exception.ApiException;
import lombok.RequiredArgsConstructor;

@Controller
@RequestMapping("/review")
@RequiredArgsConstructor
public class ReviewController {
	private final ReviewService reviewService;
	private final UserService userService;

	@PostMapping
	public String createReview(Authentication auth, CreateReviewDto createReviewDto) {
		if(auth==null) {
			throw new ApiException("로그인후 이용가능합니다. ");
		}
		UserEntity user = userService.findByUserId(auth.getName());
		reviewService.insertReview(user.getId(), createReviewDto);
		return "redirect:/book/view?id="+createReviewDto.getBookId();
	}

}
