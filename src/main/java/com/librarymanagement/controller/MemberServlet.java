package com.librarymanagement.controller;

import com.librarymanagement.dao.MemberDAO;
import com.librarymanagement.model.Member;
import java.io.IOException;
import java.sql.SQLException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet("/members")
public class MemberServlet extends BaseServlet {
    private final MemberDAO memberDAO = new MemberDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        if (!ensureAuthenticated(request, response)) {
            return;
        }

        String action = request.getParameter("action");
        try {
            if ("new".equals(action)) {
                request.setAttribute("formMode", "create");
                forward(request, response, "/WEB-INF/views/member-form.jsp");
            } else if ("edit".equals(action)) {
                int id = Integer.parseInt(request.getParameter("id"));
                request.setAttribute("member", memberDAO.findById(id));
                request.setAttribute("formMode", "edit");
                forward(request, response, "/WEB-INF/views/member-form.jsp");
            } else if ("delete".equals(action)) {
                int id = Integer.parseInt(request.getParameter("id"));
                memberDAO.delete(id);
                setFlash(request, "success", "Member deleted.");
                response.sendRedirect(request.getContextPath() + "/members");
            } else {
                request.setAttribute("members", memberDAO.findAll());
                forward(request, response, "/WEB-INF/views/members.jsp");
            }
        } catch (SQLException ex) {
            request.setAttribute("errorMessage", ex.getMessage());
            forward(request, response, "/WEB-INF/views/error.jsp");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        if (!ensureAuthenticated(request, response)) {
            return;
        }

        Member member = new Member();
        member.setMemberCode(request.getParameter("memberCode"));
        member.setFullName(request.getParameter("fullName"));
        member.setEmail(request.getParameter("email"));
        member.setPhone(request.getParameter("phone"));
        member.setAddress(request.getParameter("address"));

        try {
            String idValue = request.getParameter("id");
            if (idValue == null || idValue.isEmpty()) {
                memberDAO.insert(member);
                setFlash(request, "success", "Member added.");
            } else {
                member.setId(Integer.parseInt(idValue));
                memberDAO.update(member);
                setFlash(request, "success", "Member updated.");
            }
            response.sendRedirect(request.getContextPath() + "/members");
        } catch (SQLException ex) {
            request.setAttribute("errorMessage", ex.getMessage());
            request.setAttribute("member", member);
            request.setAttribute("formMode", request.getParameter("id") == null ? "create" : "edit");
            forward(request, response, "/WEB-INF/views/member-form.jsp");
        }
    }
}
