<%@ page language="java" import="java.util.*,utill.*,category.*,gift.*,orderPrint.*,order.*,user.*,orderproduct.*,group.*;" pageEncoding="UTF-8"  contentType="text/html;charset=utf-8"%>

<%  
request.setCharacterEncoding("utf-8");
User user = (User)session.getAttribute("user");
 
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>订单管理</title>

<link rel="stylesheet" type="text/css" rev="stylesheet" href="../style/css/bass.css" />
<link href="../style/zzsc.css" rel="stylesheet" type="text/css" />
<script src="../js/showlist.js" type="text/javascript"></script>
 
</head>

<body style="background-color:#CCCCCC;"> 

<!--   头部开始   -->
<script type="text/javascript" src="../js/jquery-1.7.2.min.js"></script>

<!--   头部结束   -->
<div class="main_a">
   <div class="main content">
    <div class="left-sider">
      <div class="operate">
        <h3> 后台管理 </h3>
        <ul id="J_navlist">
          <li >   
            <h4 >个人中心</h4>
            <div class="list-item none"> 
              <p ><a href="loginN.jsp" target="contentpage">个人中心</a></p>
              <%
     if(UserManager.checkPermissions(user,Group.Manger)){
     %> 
    <p ><a href="company.jsp" target="contentpage">公司基本信息</a></p>
    <%
     }
    %>
              
            </div>
          </li> 
          <%
           if(UserManager.checkPermissions(user, Group.dealSend)){
          %> 
          <li>       
            <h4 >订单管理</h4>
            <div class="list-item none"> 
              <p ><a href="dingdan.jsp" target="contentpage">文员派工页</a></p> 
            <!--    <p ><a href="dingdanpeidan.jsp" target="contentpage">文员打印页</a></p> -->  
              <p ><a href="dingdanprintln.jsp" target="contentpage">查看订单页</a></p>
               <p ><a href="dingdanover.jsp" target="contentpage">安装单位结款页</a></p>  
              <p ><a href="dingdanCome.jsp" target="contentpage">确认厂送票已回</a></p>
              <p ><a href="dingdango.jsp" target="contentpage">确认厂送票已消</a></p>
              <p ><a href="dingdanCharge.jsp" target="contentpage">确认厂送票已结款</a></p>
               <p ><a href="dingdancallback.jsp"  target="contentpage">客服未回访页</a></p>
              <p ><a href="javascript:void(0);" target="contentpage">调账确认页</a></p>    
            <!--   <p ><a href="dingdanDingma.jsp" target="contentpage">调账确认页</a></p>  -->
              <p ><a href="dingdanTuihuo.jsp" target="contentpage">退货订单</a></p> 
              <p ><a href="updateExcel.jsp" target="contentpage">Excel上传页</a></p>
             
            </div>  
          </li> 
          
          <%
          }
         if(UserManager.checkPermissions(user, Group.ManagerUser)){

          %> 
          <li >
            <h4 >职工管理</h4>
            <div class="list-item none">
              <p ><a href="huiyuan.jsp" target="contentpage">职工管理</a></p>
            </div>
          </li>
          <% } 
         if(UserManager.checkPermissions(user,Group.inventoryquery)){
         %>
       <li > 
            <h4 >库存管理</h4>
            <div class="list-item none"> 
              <p ><a href="inventory/receipts.jsp" target="contentpage">单据管理</a></p>
              <p ><a href="inventory/inventoryBranch.jsp" target="contentpage">库存查询</a></p>
            </div>
          </li>
         <%
          }
         if(UserManager.checkPermissions(user, Group.juese)){
         %>
            <li >
            <h4 >职位管理</h4>
            <div class="list-item none">
              <p ><a href="juesetype.jsp" target="contentpage">职位管理</a></p>
            </div>
          </li>
            <%
         } 
         
         if(UserManager.checkPermissions(user, Group.addprodoct)){
    
          %>
          <li >
            <h4 >产品管理</h4>
            <div class="list-item none">
              <p ><a href="category.jsp" target="contentpage">产品管理</a></p>

            </div>
          </li>
          
          <%
         }
         if(UserManager.checkPermissions(user, Group.branch)){
        	 
        
           %>
          <li >
            <h4 >门店管理</h4>
            <div class="list-item none">
              <p ><a href="branch.jsp" target="contentpage">门店管理</a></p>
            </div>
          </li> 
          
          
          <%
         }
          if(UserManager.checkPermissions(user, Group.locate)){
          
          
          %>
          <li > 
            <h4 >地区管理</h4>
            <div class="list-item none">
              <p ><a href="locate.jsp"  target="contentpage">地区管理</a></p>
            </div>
          </li>
          <%
          }if(UserManager.checkPermissions(user, Group.Manger)){
          %>
          
          <li > 
            <h4 >数据备份</h4>   
            <div class="list-item none">
              <p ><a href="database.jsp"  target="contentpage">数据备份</a></p>
            </div>     
          </li>
      
        <%
        }if(UserManager.checkPermissions(user, Group.sencondDealsend)){
        	%>
        	<li > 
            <h4 >工长派工</h4>     
            <div class="list-item none">
              <p ><a href="dispatch/dingdanpeidan2.jsp"  target="contentpage">工长派工</a></p>
               <%
        	 if(UserManager.checkPermissions(user,Group.println)){
        		%>
               
              <!--   <p ><a href="dispatch/dingdanprint2.jsp"  target="contentpage">工长打印</a></p> -->

               <% 
                
               } %>
               <p ><a href="dispatch/dingdan_chargep.jsp"  target="contentpage">送货结款</a></p> 
               <p ><a href="dispatch/dingdanpeidan2anzhuang.jsp"  target="contentpage">安装派工</a></p> 
             <!--   <p ><a href="dispatch/dingdanprint2anzhuang.jsp"  target="contentpage">安装打印</a></p> -->
              <p ><a href="dispatch/dingdancallback.jsp"  target="contentpage">客服未回访页</a></p>
              <p ><a href="dispatch/dingdan_charge.jsp"  target="contentpage">安装结款</a></p> 
               <p ><a href="dispatch/dingdan_chargeall.jsp"  target="contentpage">送货安装结款</a></p>  
              <p ><a href="dispatch/dingdanpeidan2s.jsp"  target="contentpage">工长查询</a></p>
            </div>     
          </li> 

        	 
        	<%	  
        	  
        }
        %>
         </ul> 
        <script type="text/javascript" language="javascript">
			navList(12);
		</script>
      </div>
    </div>
  </div>

</div>


</body>
</html>
