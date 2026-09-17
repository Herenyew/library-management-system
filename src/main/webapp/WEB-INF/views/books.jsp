<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.List" %>
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

    private boolean hasText(String value) {
        return value != null && !value.trim().isEmpty();
    }

    private String coverSrc(String value, String contextPath) {
        if (!hasText(value)) {
            return "";
        }
        String path = value.trim();
        if (path.startsWith("http://") || path.startsWith("https://")) {
            return "";
        }
        return contextPath + (path.startsWith("/") ? path : "/" + path);
    }
%>
<jsp:include page="/WEB-INF/views/partials/header.jsp" />
<%
    List<Book> books = (List<Book>) request.getAttribute("books");
%>
<div class="page-header">
    <div>
        <h1>Books</h1>
        <p>Create, update, browse, and remove books in the library catalog.</p>
    </div>
</div>
<div class="table-container">
    <div class="table-body">
        <div class="toolbar">
            <div class="search-box">
                <input type="text" placeholder="Use the catalog table below to review your book inventory">
            </div>
            <a class="btn btn-gold" href="<%= request.getContextPath() %>/books?action=new">Add Book</a>
        </div>
    </div>
    <table>
        <thead>
        <tr>
            <th style="width:74px;">Cover</th>
            <th>ID</th>
            <th>ISBN</th>
            <th>Title</th>
            <th>Author</th>
            <th>Category</th>
            <th>Year</th>
            <th>Status</th>
            <th>Actions</th>
        </tr>
        </thead>
        <tbody>
        <% if (books != null && !books.isEmpty()) {
            for (Book book : books) {
                String title = escapeHtml(book.getTitle());
                String coverUrl = escapeHtml(coverSrc(book.getCoverImageUrl(), request.getContextPath()));
                String initial = title.isEmpty() ? "LV" : String.valueOf(Character.toUpperCase(title.charAt(0)));
        %>
        <tr>
            <td class="book-cover-cell" style="width:74px;padding:10px 12px;">
                <div class="book-cover-thumb" style="position:relative;display:grid;place-items:center;overflow:hidden;width:54px;height:78px;border-radius:3px;background:linear-gradient(135deg,#314d42,#9f6a37);box-shadow:0 4px 10px rgba(26,18,8,0.16);">
                    <% if (hasText(coverUrl)) { %>
                        <img src="<%= coverUrl %>" alt="<%= title %> cover" loading="lazy" style="position:absolute;inset:0;z-index:1;width:54px;height:78px;max-width:54px;max-height:78px;object-fit:cover;" onerror="this.remove();">
                    <% } %>
                    <span class="book-cover-fallback"><%= initial %></span>
                </div>
            </td>
            <td><%= book.getId() %></td>
            <td><%= escapeHtml(book.getIsbn()) %></td>
            <td><strong><%= title %></strong></td>
            <td><%= escapeHtml(book.getAuthor()) %></td>
            <td><%= escapeHtml(book.getCategory()) %></td>
            <td><%= book.getPublishedYear() %></td>
            <td>
                <span class="badge <%= book.getAvailableCopies() > 0 ? "badge-available" : "badge-overdue" %>">
                    <%= book.getAvailableCopies() > 0 ? "Available" : "Out of stock" %>
                </span>
                <div class="muted copy-count"><%= book.getAvailableCopies() %> / <%= book.getTotalCopies() %> copies</div>
            </td>
            <td>
                <div class="actions">
                    <a class="btn secondary btn-sm" href="<%= request.getContextPath() %>/books?action=edit&id=<%= book.getId() %>">Edit</a>
                    <a class="btn danger btn-sm" href="<%= request.getContextPath() %>/books?action=delete&id=<%= book.getId() %>"
                       data-confirm-title="Confirm Delete"
                       data-confirm-message="Are you sure you want to delete book &quot;<%= title %>&quot;? This cannot be undone."
                       data-confirm-action="Delete"
                       data-busy-message="Deleting...">Delete</a>
                </div>
            </td>
        </tr>
        <%  }
           } else { %>
        <tr>
            <td colspan="9" class="empty-state">No books are available in the catalog yet.</td>
        </tr>
        <% } %>
        </tbody>
    </table>
</div>
<jsp:include page="/WEB-INF/views/partials/footer.jsp" />
