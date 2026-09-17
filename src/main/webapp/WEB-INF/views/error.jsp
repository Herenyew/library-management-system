<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<jsp:include page="/WEB-INF/views/partials/header.jsp" />
<div class="page-header">
    <div>
        <h1>Application Error</h1>
        <p>The request could not be completed because the application hit an error.</p>
    </div>
</div>
<div class="form-panel">
    <h2 class="section-title">Error Details</h2>
    <div class="form-body">
        <div class="message error">${errorMessage}</div>
        <a class="btn secondary" href="${pageContext.request.contextPath}/dashboard">Back to Dashboard</a>
    </div>
</div>
<jsp:include page="/WEB-INF/views/partials/footer.jsp" />
