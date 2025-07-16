package book.user.dto;

import java.util.List;

import lombok.Builder;
import lombok.Data;

@Data
@Builder
public class PageList {
	private int currentPage;
	int totalCount;
	int pagePerCount;
	int totalPage;
	private int startPage;
	private int endPage;
	private boolean pre;
	private boolean next;
	List<Book> list;
	String searchfield;
	String search;
}
