<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.List" %>
<%@ page import="com.librarymanagement.model.Member" %>
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
    List<Member> members = (List<Member>) request.getAttribute("members");
%>
<div class="page-header">
    <div>
        <h1>Members</h1>
        <p>Maintain member records, contacts, and library enrollment details.</p>
    </div>
</div>
<div class="table-container">
    <div class="table-body">
        <div class="toolbar">
            <div class="search-box">
                <input type="text" placeholder="Review registered members and their account information">
            </div>
            <a class="btn btn-gold" href="<%= request.getContextPath() %>/members?action=new">Add Member</a>
        </div>
    </div>
    <table>
        <thead>
        <tr>
            <th>ID</th>
            <th>Code</th>
            <th>Name</th>
            <th>Contact</th>
            <th>Address</th>
            <th>Status</th>
            <th>Actions</th>
        </tr>
        </thead>
        <tbody>
        <% if (members != null && !members.isEmpty()) {
            for (Member member : members) {
                String fullName = escapeHtml(member.getFullName());
        %>
        <tr>
            <td><%= member.getId() %></td>
            <td><%= member.getMemberCode() %></td>
            <td><strong><%= fullName %></strong></td>
            <td>
                <div><%= member.getEmail() %></div>
                <div class="muted" style="margin-top:6px;"><%= member.getPhone() %></div>
            </td>
            <td><%= member.getAddress() %></td>
            <td><span class="badge badge-available">Active</span></td>
            <td>
                <div class="actions">
                    <a class="btn secondary btn-sm" href="<%= request.getContextPath() %>/members?action=edit&id=<%= member.getId() %>">Edit</a>
                    <a class="btn danger btn-sm" href="<%= request.getContextPath() %>/members?action=delete&id=<%= member.getId() %>"
                       data-confirm-title="Confirm Delete"
                       data-confirm-message="Are you sure you want to delete member &quot;<%= fullName %>&quot;? This cannot be undone."
                       data-confirm-action="Delete"
                       data-busy-message="Deleting...">Delete</a>
                </div>
            </td>
        </tr>
        <%  }
           } else { %>
        <tr>
            <td colspan="7" class="empty-state">No member records are available yet.</td>
        </tr>
        <% } %>
        </tbody>
    </table>
</div>
<jsp:include page="/WEB-INF/views/partials/footer.jsp" />
