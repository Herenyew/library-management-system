<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="com.librarymanagement.model.Member" %>
<jsp:include page="/WEB-INF/views/partials/header.jsp" />
<%
    Member member = (Member) request.getAttribute("member");
    boolean editMode = "edit".equals(request.getAttribute("formMode"));
    String busyMessage = editMode ? "Updating member..." : "Saving member...";
    String busyButton = editMode ? "Updating..." : "Saving...";
%>
<div class="page-header">
    <div>
        <h1><%= editMode ? "Edit Member" : "Add Member" %></h1>
        <p>Store contact information and membership details for each library user.</p>
    </div>
</div>
<div class="form-panel">
    <h2 class="section-title">Member Details</h2>
    <div class="form-body">
        <% if (request.getAttribute("errorMessage") != null) { %>
            <div class="message error"><%= request.getAttribute("errorMessage") %></div>
        <% } %>
        <form action="<%= request.getContextPath() %>/members" method="post"
              data-busy-message="<%= busyMessage %>"
              data-busy-button="<%= busyButton %>">
            <% if (editMode && member != null) { %>
                <input type="hidden" name="id" value="<%= member.getId() %>">
            <% } %>
            <div class="form-grid">
                <div class="form-group">
                    <label>Member Code</label>
                    <input type="text" name="memberCode" value="<%= member != null ? member.getMemberCode() : "" %>" required>
                </div>
                <div class="form-group">
                    <label>Full Name</label>
                    <input type="text" name="fullName" value="<%= member != null ? member.getFullName() : "" %>" required>
                </div>
                <div class="form-group">
                    <label>Email</label>
                    <input type="email" name="email" value="<%= member != null ? member.getEmail() : "" %>" required>
                </div>
                <div class="form-group">
                    <label>Phone</label>
                    <input type="text" name="phone" value="<%= member != null ? member.getPhone() : "" %>" required>
                </div>
                <div class="form-group full">
                    <label>Address</label>
                    <textarea name="address" required><%= member != null ? member.getAddress() : "" %></textarea>
                </div>
            </div>
            <div class="form-actions">
                <a class="btn secondary" href="<%= request.getContextPath() %>/members">Cancel</a>
                <button type="submit"><%= editMode ? "Update Member" : "Save Member" %></button>
            </div>
        </form>
    </div>
</div>
<jsp:include page="/WEB-INF/views/partials/footer.jsp" />
