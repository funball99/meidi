<%@ page language="java" import="java.util.*,utill.*,java.text.SimpleDateFormat,category.*,orderPrint.*,gift.*,order.*,user.*,orderproduct.*,group.*;" pageEncoding="UTF-8"  contentType="text/html;charset=utf-8"%>

<%  
request.setCharacterEncoding("utf-8"); 
User user = (User)session.getAttribute("user");
String id = request.getParameter("id");
String type = request.getParameter("type");
String message = "";
String username = "";
String htmlname = "";
Order order = OrderManager.getOrderID(user, Integer.valueOf(id));

HashMap<Integer,User> usermap = UserManager.getMap();

if((Order.orderinstall+"").equals(type)){
	message = "安装单 "; 
	htmlname = "安装员";
	username = usermap.get(order.getInstallid()).getUsername();
}else if((Order.orderpeisong+"").equals(type)){
	message = "送货安装单"; 
	htmlname = "送货员";
	username = usermap.get(order.getSendId()).getUsername();
}else if((Order.returns+"").equals(type)  || (Order.orderreturn+"").equals(type)){
	message = "退货单"; 
	htmlname = "退货员";
	username = usermap.get(order.getSendId()).getUsername();
}else if((Order.ordersong+"").equals(type)){
	message = "只安装(门店提货)"; 
	htmlname = "送货员";
	username = usermap.get(order.getSendId()).getUsername();
}else if((Order.ordersong+"").equals(type)){
	message = "只安装(顾客已提)";     
	htmlname = "送货员";
	username = usermap.get(order.getSendId()).getUsername();
}



int iddd = 0;


User send = usermap.get(order.getDealsendId());  

HashMap<Integer,Category> categorymap = CategoryManager.getCategoryMap();

Map<Integer,List<Gift>> gMap = GiftManager.getOrderStatuesM(user);
Map<Integer,List<OrderProduct>> OrPMap = OrderProductManager.getOrderStatuesM(user);

SimpleDateFormat df2 = new SimpleDateFormat("yyyy年MM月dd日");
SimpleDateFormat df = new SimpleDateFormat("yyyyMMdd");
Date date = new Date();
String time = df2.format(date);
String pid = df.format(date);
System.out.println(pid);
%>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>打印页面</title> 
<style media=print type="text/css">   
.noprint{visibility:hidden}  
body{ 
   bgcolor:"white";
   background:"" ;    
}    
</style>
<link rel="stylesheet" type="text/css" rev="stylesheet" href="../css/bass.css" />
<link rel="stylesheet" href="../css/songhuo.css"/>
<script type="text/javascript" src="../js/jquery-1.7.2.min.js"></script>

<script type="text/javascript">
 function println(){
	 
	 window.print();
	 
	 	 
 }
 
 
</script>
</head>

<body>
  
<table width="1010"> 
  <tr>
    <td colspan="2">&nbsp;</td>
    <td width="384" rowspan="2" align="center" style="font-size:30px; font-family:"楷体";><strong><%=message %></strong></td>
    <td width="300"><strong><FONT size=5>单&nbsp;&nbsp;号：<%=order.getPrintlnid() == null?"":order.getPrintlnid()%></strong></FONT></td> 
  </tr> 
  <tr>    
    <td width="110">&nbsp;&nbsp;&nbsp;<strong>&nbsp;门店：</strong></td> 
    <td width="212" style="font-size:25px; font-family:"楷体";><strong><%=order.getBranch()+"("+usermap.get(Integer.valueOf(order.getSaleID())).getUsername() +")"%></strong></td>
    <td><strong><FONT size=4>销售日期：<%=order.getSaleTime() %></strong></FONT></td>
  </tr>
 
</table>
<table width="1010" border="0" cellpadding="0" cellspacing="0"  id="t"  style="font-size:28px; font-weight:bolder;">
<tr></tr>
<tr>
  <td height="30" colspan="5" align="center" valign="middle"><table width="100%" border="0" cellspacing="0" cellpadding="0">
    <tr>
      <td width="14%" height="30" align="center" valign="middle" id="d">顾客姓名</td>
      <td width="14%" align="center" valign="middle" id="d">&nbsp;<%=order.getUsername() %></td>
      <td width="9%" align="center" valign="middle" id="d">电话</td>
      <td width="13%" align="center" valign="middle" id="d">&nbsp;<%=order.getPhone1() %></td>
      <td width="9%" align="center" valign="middle" id="d">电话2</td>
      <td width="13%" align="center" valign="middle" id="d">&nbsp;<%=(order.getPhone2() == null || order.getPhone2() == "")?"":order.getPhone2()  %></td>
      <td width="13%" align="center" valign="middle" id="d">预约日期</td> 
      <td width="15%" align="center" valign="middle" id="d"><span style="font-size:20px;">&nbsp;<%=order.getOdate() %></span></td>
    </tr>
  </table></td>
</tr> 
<tr>
  <td width="13%" height="30" align="center" valign="middle" bgcolor="#FFFFFF" id="d">地&nbsp;&nbsp;&nbsp; 址</td>
  <td width="1%" height="30" align="center" valign="middle" bgcolor="#FFFFFF" id="e"></td>  
  <td width="47%" height="30" align="center" valign="middle" bgcolor="#FFFFFF" id="d">&nbsp;<%=order.getLocate()+order.getLocateDetail() %></td>
  <td width="13%" height="30" align="center" valign="middle" bgcolor="#FFFFFF" id="d"><%=htmlname %></td> 
  <td width="26%" height="30" bgcolor="#FFFFFF" id="e">&nbsp;<%=username %></td>
</tr> 
<tr>  
  <td height="30" colspan="5" align="center" valign="middle" bgcolor="#FFFFFF"><table width="100%" border="0" cellspacing="0" cellpadding="0">
    <% 
		     List<OrderProduct> listor = OrPMap.get(order.getId());
             int  count =  listor.size();
             if(null != listor){
                 for(int g = 0 ;g<listor.size();g++){ 
                	 OrderProduct op = listor.get(g);
			    	 if(0  == op.getStatues()){
			    		 iddd++;
			    			 %>
    <tr>
      <td width="4%" height="30" align="center" valign="middle" id="d"><%=iddd %></td>
      <td width="9%" height="30" align="center" valign="middle" id="d">品类</td>
      <td width="17%" height="30" align="center"  id="d">&nbsp;<%=categorymap.get(Integer.valueOf(op.getCategoryId())).getName() %></td>
      <td width="11%" height="30" align="center" valign="middle" id="d">型号</td>
      <td width="38%" height="30" align="center" valign="middle" id="d"><%=op.getSendType() %></td>
      <td width="12%" height="30" align="center" valign="middle" id="d">数量</td>
      <td width="9%" height="30" align="center"valign="middle" id="e"><%=op.getCount() %></td>
    </tr>
    <%	 
			    		
			    	 }
                 } 
             }
     %>
    <%  
    
     List<Gift> glists = gMap.get(Integer.valueOf(id));
    String str = "";
		     if(null != glists){ 
		    	 String statues = "需配送";
			     for(int g = 0 ;g<glists.size();g++){
			    	 Gift op = glists.get(g);
	 		    	 if(null !=op && 1!= op.getStatues()){
	 		    		if(2 == op.getStatues()){
	 		    			 str = "(门店提)";
	 		    		 }
	 		    		iddd++;
			    		 %>
    <tr>
      <td width="4%" height="30" align="center" valign="middle" id="d"><%=iddd %></td>
      <td width="9%" height="30" align="center" valign="middle" id="d">品类</td>
      <td width="17%" height="30" align="center"  id="d">&nbsp;赠品<%=str %></td>
      <td width="11%" height="30" align="center" valign="middle" id="d">型号</td>
      <td width="38%" height="30" align="center" valign="middle" id="d"><%=op.getName() %></td>
      <td width="12%" height="30" align="center" valign="middle" id="d">数量</td>
      <td width="9%" height="30" align="center"valign="middle" id="e"><%=op.getCount() %></td>
    </tr>
    <%     
			    	 }
			    	 
			     }
		     }
		    	 %>
  </table></td>
</tr>
<tr>
  <td width="13%" height="50" align="center" valign="middle" bgcolor="#FFFFFF" id="f">备注</td>
  <td height="30" width="57" colspan="2" align="left" valign="bottom" bgcolor="#FFFFFF">&nbsp;<%=order.getRemark() %></td>
  <td height="30" colspan="2" align="left" valign="bottom" bgcolor="#FFFFFF" width="30%">顾客签字：</td>
  
</tr> 
</table>
<center> <input class="noprint" type=button name='button_export' title='打印1' onclick="println()" value="打印"></input></center>
 <p class="noprint"></p>
</body>
</html>


