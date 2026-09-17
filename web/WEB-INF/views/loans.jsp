<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.List" %>
<%@ page import="java.time.LocalDate" %>
<%@ page import="com.librarymanagement.model.Book" %>
<%@ page import="com.librarymanagement.model.Member" %>
<%@ page import="com.librarymanagement.model.Loan" %>
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
    List<Loan> loans = (List<Loan>) request.getAttribute("loans");
    List<Book> books = (List<Book>) request.getAttribute("books");
    List<Member> members = (List<Member>) request.getAttribute("members");
    String issueDate = LocalDate.now().toString();
    String dueDate = LocalDate.now().plusDays(14).toString();
%>
<div class="page-header">
    <div>
        <h1>Loans</h1>
        <p>Issue books to members and process returns through the circulation desk.</p>
    </div>
</div>
<div class="table-container">
    <div class="table-body">
        <div class="toolbar">
            <div class="search-box">
                <input type="text" placeholder="Track active and returned book loans from this register">
            </div>
            <button type="button" class="btn btn-gold" data-open-loan-dialog>Issue Book</button>
        </div>
    </div>
    <table>
        <thead>
        <tr>
            <th>ID</th>
            <th>Book</th>
            <th>Member</th>
            <th>Issue Date</th>
            <th>Due Date</th>
            <th>Return Date</th>
            <th>Status</th>
            <th>Actions</th>
        </tr>
        </thead>
        <tbody>
        <% if (loans != null && !loans.isEmpty()) {
            for (Loan loan : loans) { %>
        <tr>
            <td><%= loan.getId() %></td>
            <td><strong><%= loan.getBookTitle() %></strong></td>
            <td><%= loan.getMemberName() %></td>
            <td><%= loan.getIssueDate() %></td>
            <td><%= loan.getDueDate() %></td>
            <td><%= loan.getReturnDate() == null ? "-" : loan.getReturnDate() %></td>
            <td>
                <span class="badge <%= "RETURNED".equals(loan.getStatus()) ? "badge-returned" : "badge-borrowed" %>">
                    <%= loan.getStatus() %>
                </span>
            </td>
            <td>
                <div class="actions">
                    <% if ("BORROWED".equals(loan.getStatus())) { %>
                    <a class="btn secondary btn-sm" href="<%= request.getContextPath() %>/loans?action=return&id=<%= loan.getId() %>"
                       data-busy-message="Returning book...">Return</a>
                    <% } else { %>
                    <span class="muted">Completed</span>
                    <% } %>
                </div>
            </td>
        </tr>
        <%  }
           } else { %>
        <tr>
            <td colspan="8" class="empty-state">No loan records are available yet.</td>
        </tr>
        <% } %>
        </tbody>
    </table>
</div>
<div class="form-backdrop" data-loan-dialog aria-hidden="true" hidden>
    <div class="loan-modal-card" role="dialog" aria-modal="true" aria-labelledby="loan-modal-title">
        <button type="button" class="modal-close" data-close-loan-dialog aria-label="Close issue book form">&times;</button>
        <h2 id="loan-modal-title">Issue Book Loan</h2>
        <form action="<%= request.getContextPath() %>/loans" method="post"
              data-busy-message="Issuing book..."
              data-busy-button="Issuing...">
            <div class="form-grid modal-grid">
                <div class="form-group full">
                    <label>Select Book *</label>
                    <select name="bookId" required>
                        <option value="">-- Choose an available book --</option>
                        <% if (books != null) {
                            for (Book book : books) {
                                if (book.getAvailableCopies() > 0) { %>
                        <option value="<%= book.getId() %>">
                            <%= escapeHtml(book.getTitle()) %> - <%= escapeHtml(book.getAuthor()) %>
                        </option>
                        <%      }
                            }
                        } %>
                    </select>
                </div>
                <div class="form-group full">
                    <label>Select Member *</label>
                    <select name="memberId" required>
                        <option value="">-- Choose a member --</option>
                        <% if (members != null) {
                            for (Member member : members) { %>
                        <option value="<%= member.getId() %>">
                            <%= escapeHtml(member.getFullName()) %>
                        </option>
                        <%  }
                        } %>
                    </select>
                </div>
                <div class="form-group">
                    <label>Issue Date</label>
                    <input type="date" name="issueDate" value="<%= issueDate %>" required>
                </div>
                <div class="form-group">
                    <label>Due Date *</label>
                    <input type="date" name="dueDate" value="<%= dueDate %>" required>
                </div>
            </div>
            <div class="modal-actions">
                <button type="button" class="btn secondary" data-close-loan-dialog>Cancel</button>
                <button type="submit" class="btn btn-gold">Issue Loan</button>
            </div>
        </form>
    </div>
</div>
<jsp:include page="/WEB-INF/views/partials/footer.jsp" />
