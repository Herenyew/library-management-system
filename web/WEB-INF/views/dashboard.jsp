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
<%
    List<Book> featuredBooks = (List<Book>) request.getAttribute("featuredBooks");
%>
<jsp:include page="/WEB-INF/views/partials/header.jsp" />
<div class="page-header">
    <div>
        <h1>Dashboard</h1>
        <p>Monitor books, members, and borrowing activity from one command center.</p>
    </div>
</div>
<div class="stats-grid">
    <div class="stat-card">
        <div class="stat-number">${bookCount}</div>
        <div class="stat-label">Total Books</div>
        <div class="stat-meta">Books currently stored in the library catalog.</div>
    </div>
    <div class="stat-card forest">
        <div class="stat-number">${memberCount}</div>
        <div class="stat-label">Total Members</div>
        <div class="stat-meta">Registered members with active library records.</div>
    </div>
    <div class="stat-card rust">
        <div class="stat-number">${activeLoanCount}</div>
        <div class="stat-label">Active Loans</div>
        <div class="stat-meta">Books currently checked out and awaiting return.</div>
    </div>
</div>
<div class="panel">
    <h2 class="section-title">Featured Covers</h2>
    <div class="panel-body">
        <% if (featuredBooks != null && !featuredBooks.isEmpty()) { %>
            <div class="featured-books" style="display:grid;grid-template-columns:repeat(auto-fit,minmax(120px,1fr));gap:20px;align-items:start;">
                <% for (Book book : featuredBooks) {
                    String title = escapeHtml(book.getTitle());
                    String author = escapeHtml(book.getAuthor());
                    String coverUrl = escapeHtml(coverSrc(book.getCoverImageUrl(), request.getContextPath()));
                    String initial = title.isEmpty() ? "LV" : String.valueOf(Character.toUpperCase(title.charAt(0)));
                %>
                    <a class="featured-book" href="<%= request.getContextPath() %>/books" style="display:block;min-width:0;">
                        <div class="featured-cover" style="position:relative;display:grid;place-items:center;overflow:hidden;width:100%;aspect-ratio:2/3;border-radius:4px;background:linear-gradient(135deg,#314d42,#9f6a37);box-shadow:0 10px 18px rgba(26,18,8,0.18);">
                            <% if (hasText(coverUrl)) { %>
                                <img src="<%= coverUrl %>" alt="<%= title %> cover" loading="lazy" style="position:absolute;inset:0;z-index:1;width:100%;height:100%;object-fit:cover;" onerror="this.remove();">
                            <% } %>
                            <span class="cover-fallback"><%= initial %></span>
                        </div>
                        <div class="featured-title" style="margin-top:12px;font-size:13px;font-weight:600;line-height:1.25;"><%= title %></div>
                        <div class="featured-author" style="margin-top:4px;color:var(--smoke);font-size:12px;line-height:1.3;"><%= author %></div>
                    </a>
                <% } %>
            </div>
        <% } else { %>
            <div class="empty-state">No cover images are available yet.</div>
        <% } %>
    </div>
</div>
<jsp:include page="/WEB-INF/views/partials/footer.jsp" />
