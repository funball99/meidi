<%@ page language="java"  import="java.util.*,category.*,group.*,user.*;"  pageEncoding="UTF-8"  contentType="text/html;charset=utf-8"%>
<% 
request.setCharacterEncoding("utf-8"); 
User user = (User)session.getAttribute("user");
List<User> list = UserManager.getUsersNodelete(user);  
List<User> listg = new ArrayList<User>(); 
 
listg = UserManager.getUsersNodeleteDown(user, 1); 
 
HashMap<Integer,Group> map = GroupManager.getGroupMap();

%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>会员管理页面</title>
 
<link rel="stylesheet" type="text/css" rev="stylesheet" href="../style/css/bass.css" />
<script type="text/javascript" src="../js/jquery-1.7.2.min.js"></script>
<script type="text/javascript" src="../js/common.js"></script>
<script type="text/javascript">

function changes(id,name,statues){
	if(statues == 2){
	question = confirm("确定要删除"+name+"吗？");
	if (question == "0"){
       return ;
	}
	}
	$.ajax({ 
        type: "post", 
         url: "server.jsp",
         data:"method=jihuo&id="+id+"&statues="+statues,
         dataType: "", 
         success: function (data) {
           window.location.href="huiyuan.jsp";
           }, 
         error: function (XMLHttpRequest, textStatus, errorThrown) { 
        // alert(errorThrown); 
            } 
           });
	
	
}
</script>
</head>

<body>
<!--   头部开始   -->

 <jsp:include flush="true" page="head.jsp">
  <jsp:param name="dmsn" value="" />
  </jsp:include>

<!--   头部结束   -->

<div class="main">
 
     
 <!--       -->    
     
     <div class="">
   <div class="weizhi_head">现在位置：职工管理</div> 
   <!--      
   <div class="main_r_tianjia">
   
   <ul>                                                                                                  
     <li><a href="huiyuanAdd.jsp">添加职工</a></li>
     </ul>
   
   </div> 
     -->
   <div class="table-list"> 
<table width="100%" cellspacing="1" style="background-color:black;"> 
	<thead>
		<tr>
			
			<th align="left">职工序列号</th>
			<th align="left">职工名称</th>
			<th align="left">职工电话</th>
			<th align="left">职工类别</th>
			<th align="left">主管</th> 
			<th align="left">所属门店</th>
			<th align="left">入职日期</th>
            <th align="left">是否审核通过</th>
			<!--  <th align="left">修改</th> -->
		</tr>
	</thead>
<tbody> 
<% 
  for(int i =0 ;i<list.size();i++){
	 User u = list.get(i) ;
	  
%> 
    <tr  id="<%=u.getId() %>" class="asc"  onclick="updateClass(this)">    
    
		
		
		<!-- <td align="left"><%=u.getId() %></td>   -->
		<td align="left"><%=i+1 %></td>
		<td align="left"><%=u.getUsername() %></td>
		<td align="left"><%=u.getPhone() %></td>
		<td align="left"><%=map.get(u.getUsertype()).getName() %></td>
		<td align="left"><%=u.getCharge()==null?"暂无主管":u.getCharge()%></td>
		<td align="left"><%=u.getBranch() %></td>
		<td align="left"><%=u.getEntryTime() %></td> 
		<td align="left">
		 <% 
		   if(!UserManager.checkPermissions(u, Group.Manger)){
		   if(0 == u.getStatues()){
		 %> 
		 否
		 <input type="button" onclick="changes('<%=u.getId()%>','',1)"  value="激活"/>
		   <input type="button" onclick="changes('<%=u.getId()%>','<%=u.getUsername() %>',2)"  value="删除"/>
		 <%
		   }else {
		 %> 
		 是
		 <input type="button" onclick="changes('<%=u.getId()%>','',0)"  value="关闭"/>
		  <input type="button" onclick="changes('<%=u.getId()%>','<%=u.getUsername() %>',2)"  value="删除"/>
		 <%
	   }
		   }
		 %>
		 
		 </td>      
		<!--
		 <td align="left">
			<a href="huiyuanUpdate.jsp?id=<%=u.getId() %>">[修改]</a>
		</td>
		 -->
    </tr>
    <% } %>
    
    <% 
     if(listg != null ){
    	 
 
  for(int i =0 ;i<listg.size();i++){
	 User u = listg.get(i) ;
	 
%> 
    <tr class="asc" onclick="updateClass(this)">
    
		
		
		<!--  <td align="left"><%=u.getId() %></td>  -->
		<td align="left"><%=list.size()+1+i %></td>
		<td align="left"><%=u.getUsername() %></td>
		<td align="left"><%=u.getPhone() %></td> 
		<td align="left"><%=map.get(u.getUsertype()).getName() %></td>
		<td align="left"><%=u.getCharge()==null?"暂无主管":u.getCharge()%></td>
		<td align="left"><%=u.getBranch() %></td>
		<td align="left"><%=u.getEntryTime() %></td> 
		<td align="left">
		 <%
		   if(0 == u.getStatues()){
		 %>
		 否
		 <input type="button" onclick="changes('<%=u.getId()%>',1)"  value="激活"/>
		   <input type="button" onclick="changes('<%=u.getId()%>',2)"  value="删除"/>
		 <%
		   }else {
		 %> 
		 是
		 <input type="button" onclick="changes('<%=u.getId()%>',0)"  value="关闭"/>
		  <input type="button" onclick="changes('<%=u.getId()%>',2)"  value="删除"/>
		 <%
	   }
		 %>
		 
		 </td>      
		<!--  
		 <td align="left">
			<a href="huiyuanUpdate.jsp?id=<%=u.getId() %>" >[修改]</a>
		</td>
		-->  
    </tr>
    <% }
   
      }%>
</tbody>
</table>
 
<div class="btn">
 
</div>
<div id="pages"></div>
</div>  
     
     
     </div>


</div>



</body>
</html>
