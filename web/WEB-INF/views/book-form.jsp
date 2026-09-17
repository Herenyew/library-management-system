<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="com.librarymanagement.model.Book" %>
<%!
    private String escapeHtml(String value) {
        if (value == null) {
            return "";
        }
        return value.replace("&", "&amp;")
                .replace("\"", "&quot;")
                .replace("<", "&lt;")
                .replace(">", "&gt;");
    }
%>
<jsp:include page="/WEB-INF/views/partials/header.jsp" />
<%
    Book book = (Book) request.getAttribute("book");
    boolean editMode = "edit".equals(request.getAttribute("formMode"));
    String busyMessage = editMode ? "Updating book..." : "Saving book...";
    String busyButton = editMode ? "Updating..." : "Saving...";
%>
<div class="page-header">
    <div>
        <h1><%= editMode ? "Edit Book" : "Add Book" %></h1>
        <p>Enter catalog details and availability information for this title.</p>
    </div>
</div>
<div class="form-panel">
    <h2 class="section-title">Book Details</h2>
    <div class="form-body">
        <% if (request.getAttribute("errorMessage") != null) { %>
            <div class="message error"><%= request.getAttribute("errorMessage") %></div>
        <% } %>
        <form action="<%= request.getContextPath() %>/books" method="post"
              data-busy-message="<%= busyMessage %>"
              data-busy-button="<%= busyButton %>">
            <% if (editMode && book != null) { %>
                <input type="hidden" name="id" value="<%= book.getId() %>">
            <% } %>
            <div class="form-grid">
                <div class="form-group">
                    <label>ISBN</label>
                    <input type="text" name="isbn" value="<%= book != null ? book.getIsbn() : "" %>" required>
                </div>
                <div class="form-group">
                    <label>Title</label>
                    <input type="text" name="title" value="<%= book != null ? book.getTitle() : "" %>" required>
                </div>
                <div class="form-group">
                    <label>Author</label>
                    <input type="text" name="author" value="<%= book != null ? book.getAuthor() : "" %>" required>
                </div>
                <div class="form-group">
                    <label>Category</label>
                    <input type="text" name="category" value="<%= book != null ? book.getCategory() : "" %>" required>
                </div>
                <div class="form-group">
                    <label>Published Year</label>
                    <input type="number" name="publishedYear" value="<%= book != null ? book.getPublishedYear() : "" %>" required>
                </div>
                <div class="form-group">
                    <label>Total Copies</label>
                    <input type="number" name="totalCopies" min="1" value="<%= book != null ? book.getTotalCopies() : "" %>" required>
                </div>
                <div class="form-group">
                    <label>Available Copies</label>
                    <input type="number" name="availableCopies" min="0" value="<%= book != null ? book.getAvailableCopies() : "" %>" required>
                </div>
                <div class="form-group full">
                    <label>Cover Image File</label>
                    <input type="text" name="coverImageUrl" value="<%= book != null ? escapeHtml(book.getCoverImageUrl()) : "" %>">
                </div>
            </div>
            <div class="form-actions">
                <a class="btn secondary" href="<%= request.getContextPath() %>/books">Cancel</a>
                <button type="submit"><%= editMode ? "Update Book" : "Save Book" %></button>
            </div>
        </form>
    </div>
</div>
<jsp:include page="/WEB-INF/views/partials/footer.jsp" />
