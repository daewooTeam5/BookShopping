package global.security;

import java.io.IOException;

import org.springframework.security.core.Authentication;
import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.web.authentication.AuthenticationSuccessHandler;

public class CustomAuthenticationSuccessHandler implements AuthenticationSuccessHandler {

    @Override
    public void onAuthenticationSuccess(javax.servlet.http.HttpServletRequest request, javax.servlet.http.HttpServletResponse response,
                                        Authentication authentication) throws IOException, javax.servlet.ServletException {
        String redirectUrl = "/book/list"; // 기본은 일반 사용자

        for (GrantedAuthority auth : authentication.getAuthorities()) {
            if (auth.getAuthority().equals("ROLE_ADMIN")) {
                redirectUrl = "/book/admin/list";
                break;
            }
        }
        response.sendRedirect(redirectUrl);
    }
}
