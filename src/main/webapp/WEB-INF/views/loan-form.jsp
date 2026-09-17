<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.List" %>
<%@ page import="com.librarymanagement.model.Book" %>
<%@ page import="com.librarymanagement.model.Member" %>
<jsp:include page="/WEB-INF/views/partials/header.jsp" />
<%
    List<Book> books = (List<Book>) request.getAttribute("books");
    List<Member> members = (List<Member>) request.getAttribute("members");
%>
<div class="page-header">
    <div>
        <h1>Issue Book</h1>
        <p>Create a borrowing record linking a selected book to a member.</p>
    </div>
</div>
<div class="form-panel">
    <h2 class="section-title">Loan Details</h2>
    <div class="form-body">
        <% if (request.getAttribute("errorMessage") != null) { %>
            <div class="message error"><%= request.getAttribute("errorMessage") %></div>
        <% } %>
        <form action="<%= request.getContextPath() %>/loans" method="post"
              data-busy-message="Issuing book..."
              data-busy-button="Issuing...">
            <div class="form-grid">
                <div class="form-group">
                    <label>Book</label>
                    <select name="bookId" required>
                        <option value="">Select a book</option>
                        <% if (books != null) {
                            for (Book book : books) { %>
                        <option value="<%= book.getId() %>">
                            <%= book.getTitle() %> (<%= book.getAvailableCopies() %> available)
                        </option>
                        <%  }
                           } %>
                    </select>
                </div>
                <div class="form-group">
                    <label>Member</label>
                    <select name="memberId" required>
                        <option value="">Select a member</option>
                        <% if (members != null) {
                            for (Member member : members) { %>
                        <option value="<%= member.getId() %>">
                            <%= member.getFullName() %> - <%= member.getMemberCode() %>
                        </option>
                        <%  }
                           } %>
                    </select>
                </div>
                <div class="form-group">
                    <label>Issue Date</label>
                    <input type="date" name="issueDate" required>
                </div>
                <div class="form-group">
                    <label>Due Date</label>
                    <input type="date" name="dueDate" required>
                </div>
            </div>
            <div class="form-actions">
                <a class="btn secondary" href="<%= request.getContextPath() %>/loans">Cancel</a>
                <button type="submit">Issue Book</button>
            </div>
        </form>
    </div>
</div>
<jsp:include page="/WEB-INF/views/partials/footer.jsp" />
