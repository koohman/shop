<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    // 메인 페이지는 상품 목록으로 리다이렉트
    response.sendRedirect(request.getContextPath() + "/products");
%>
