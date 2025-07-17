<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="Model.Account" %>

<%
    // Lấy thông tin tài khoản từ session
    Account account = (Account) session.getAttribute("account");
    
    // Chỉ hiển thị Subiz chat cho role user (0), không hiển thị cho role admin (1)
    if (account == null || account.getRole() == 0) {
%>
<!<!-- Subiz Chat -->
<script>
      window._sbzaccid = 'acsjohqbflsylnzfqogm'
      window.subiz = function () {
            window.subiz.q.push(arguments)
      }
      window.subiz.q = []
      window.subiz('setAccount', window._sbzaccid)
</script>
<script src="https://widget.subiz.net/sbz/app.js?account_id=acpzooihzhalzeskamky"></script>

<script src="https://widget.subiz.net/sbz/app.js?account_id=acpzooihzhalzeskamky"></script>
<%
    }
%>