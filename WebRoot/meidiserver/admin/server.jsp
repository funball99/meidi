<%@ page language="java" import="java.util.*,message.*,inventory.*,branchtype.*,user.*,utill.*,locate.*,branch.*,order.*,orderPrint.*,category.*,group.*,grouptype.*;" pageEncoding="utf-8"%>
<%

request.setCharacterEncoding("utf-8");

User user = (User)session.getAttribute("user");
// peidan
String method = request.getParameter("method");
   
//System.out.println("******2134*******method"+method);
 
if("peidan".equals(method)){ 
	String uid = request.getParameter("uid"); 
	String id = request.getParameter("id");  
	int statues = OrderManager.updateStatues(user,method,Integer.valueOf(uid), id);  
	//int i = OrderManager.updatePeidan(Integer.valueOf(uid), Integer.valueOf(id));
	response.getWriter().write(""+statues); 
	response.getWriter().flush();  
	response.getWriter().close();  // deleteOrder
	
}else if("deleteOrder".equals(method)){ 
	String id = request.getParameter("id");
	String[] list = id.split(",");
	int count = 0 ; 
	for(int i=0;i<list.length;i++){ 
		boolean flag = OrderManager.delete(Integer.valueOf(list[i]));
	    if(flag){
	    	count ++ ;
	    }
	}
	 
	//int statues = OrderManager.delete(id); 
	//int i = OrderManager.updatePeidan(Integer.valueOf(uid), Integer.valueOf(id));
	response.getWriter().write(""+count);  
	response.getWriter().flush();  
	response.getWriter().close();  
}else if("dingdaned".equals(method)){  
	String id = request.getParameter("id"); 
	String oid = request.getParameter("oid");
	String statues = request.getParameter("statues");
	String uid = request.getParameter("uid");
	if(StringUtill.isNull(uid)){
		uid = "-1"; 
	} 
	System.out.println("uid"+uid);
	OrderPrintlnManager.updateOrderStatues(user,Integer.valueOf(id),Integer.valueOf(oid),Integer.valueOf(uid),Integer.valueOf(statues)); 
}else if("category_add".equals(method)){     
	String categoryName = request.getParameter("categoryName");
	boolean b = CategoryManager.getName(categoryName);
	response.getWriter().write(""+b);
	response.getWriter().flush();
	response.getWriter().close();
}else if("locate".equals(method)){ 
	String locateName = request.getParameter("id");
	LocateManager.save(locateName);
}else if("jusetype".equals(method)){ 
	String jueseName = request.getParameter("id");
	GrouptypeManager.save(jueseName); 
}else if("branch".equals(method)){ // branchis 
	String locateName = request.getParameter("id");
	String pid = request.getParameter("pid");
	//BranchManager.save(locateName,pid);        
}else if("branchis".equals(method)){ // branchis 
	String locateName = request.getParameter("id");
	String pid = request.getParameter("pid");
	boolean flag = BranchManager.isname(locateName);  
	response.getWriter().write(""+flag);
	response.getWriter().flush(); 
	response.getWriter().close();  
}else if("branchtype".equals(method)){ 
	String locateName = request.getParameter("id");
	System.out.println(locateName);  
	BranchTypeManager.save(locateName);  
	//branchtypeupdate
}else if("branchtypeupdate".equals(method)){  
	String bid = request.getParameter("bid");
	String c = request.getParameter("id");
	BranchTypeManager.update(c, bid) ; 
	//branchtypeupdate
}else if("grouptypeupdate".equals(method)){ 
	String bid = request.getParameter("bid");
	String c = request.getParameter("id");
	GrouptypeManager.update(c, bid) ;    
	//branchtypeupdate
}else if("jihuo".equals(method)){ 
	String id = request.getParameter("id");
	String statues = request.getParameter("statues");
	UserManager.setStatues(Integer.valueOf(id), Integer.valueOf(statues));
}else if("duanhuo".equals(method)){ 
	String id = request.getParameter("id"); 
	String statues = request.getParameter("statues");
	CategoryManager.setStatues(Integer.valueOf(id), Integer.valueOf(statues));
}else if("huiyuan_add".equals(method)){ 
	System.out.println("&&&&&"); 
	String categoryName = request.getParameter("huiyuanName");
	boolean b = UserManager.getName(categoryName);
	response.getWriter().write(""+b);
	response.getWriter().flush(); 
	response.getWriter().close();   
}else if("orderDingma".equals(method) || "orderGo".equals(method) || "orderCome".equals(method) || "orderCharge".equals(method)  || "print2".equals(method) || "print3".equals(method)   || "print4".equals(method)  || "print".equals(method) || "orderover".equals(method) || "statuescallback".equals(method) || "statuespaigong".equals(method) || "statuesinstall".equals(method) || "statuesinstalled".equals(method) || "printdingma".equals(method) || "statuescallback".equals(method) || "wenyuancallback".equals(method)){  
	String id = request.getParameter("id");   
	int statues = OrderManager.updateStatues(user,method,Order.query, id);  
	response.getWriter().write(""+statues); 
	response.getWriter().flush();   
	response.getWriter().close();  //orderDingma
}else if("huiyuan_zhuguan".equals(method)){ 
	System.out.println(12);	 	 
	String type = request.getParameter("type"); 
	List<String> list = UserManager.getUsersregist(Integer.valueOf(type)); 
	String str = StringUtill.GetJson(list);	
	response.getWriter().write(str); 
	response.getWriter().flush();   
	response.getWriter().close();
}else if("juese_add".equals(method)){ 
	String categoryName = request.getParameter("jueseName");
	boolean b = GroupManager.getName(categoryName);
	response.getWriter().write(""+b);
	response.getWriter().flush(); 
	response.getWriter().close();
}else if("headremind".equals(method)){
	HashMap<String,Integer> map = new HashMap<String,Integer>(); 
	List<User> ulist = UserManager.getUserszhuce(user);
	int ucount = 0 ;     
	if(ulist != null){  
		ucount = UserManager.getUserszhuce(user).size(); 
	} 
	int mcount = OrderManager.getOrderlistcount(user,Group.dealSend,Order.motify ,0,0,"id",""); 
	int rcount = OrderManager.getOrderlistcount(user,Group.dealSend,Order.release,0,0,"id","");
	int ncount = OrderManager.getOrderlistcount(user,Group.dealSend,Order.neworder,0,0,"id",""); 
	int recount = OrderManager.getOrderlistcount(user,Group.dealSend,Order.returns,0,0,"id",""); 
	map.put("ucount", ucount);
	map.put("mcount", mcount);
	map.put("rcount", rcount);
	map.put("ncount",ncount);    
	map.put("recount",recount); 
	String strmap = StringUtill.GetJson(map);
	response.getWriter().write(strmap);  
	response.getWriter().flush(); 
	response.getWriter().close();
}else if("disatchpHeadremind".equals(method)){  
	HashMap<String,Integer> map = new HashMap<String,Integer>(); 
	int dcount = OrderManager.getOrderlistcount(user,Group.sencondDealsend,Order.dispatch,0,0,"id","");  
	int icount = OrderManager.getOrderlistcount(user,Group.sencondDealsend,Order.installonly,0,0,"id","");   
	//int ncount = OrderManager.getOrderlistcount(user,Group.dealSend,Order.neworder,0,0,"id",""); 
	List<User> ulist = UserManager.getUserszhuce(user);
	int hcount = 0 ;     
	if(ulist != null){   
		hcount = UserManager.getUserszhuce(user).size(); 
	} 
	
	
	int rcount = OrderManager.getOrderlistcount(user,Group.sencondDealsend,Order.release,0,0,"id",""); 
	map.put("dcount", dcount);
	map.put("icount", icount);  
	map.put("hcount",hcount);    
	map.put("rcount",rcount);    
	String strmap = StringUtill.GetJson(map);
	response.getWriter().write(strmap);  
	response.getWriter().flush(); 
	response.getWriter().close(); //inventorydetail
}else if("inventory".equals(method)){ 
	 
	String branch = request.getParameter("branch");
	String ctype = request.getParameter("ctype"); 
	String time = request.getParameter("time");
	
	List<InventoryBranch> list = InventoryBranchManager.getCategory(branch, ctype); 
	System.out.println(time+"time");
	if(!StringUtill.isNull(time)){ 
		session.setAttribute("inventorytime", time);
	}else {   
		session.removeAttribute("inventorytime");	
	}
	String str = StringUtill.GetJson(list); 
	response.getWriter().write(str);   
	response.getWriter().flush(); 
	response.getWriter().close(); //inventory
}else if("inventorydetail".equals(method)){  

	String ctype = request.getParameter("ctype"); 
	String branchid = request.getParameter("branchid");
	String time = (String)session.getAttribute("inventorytime");
	if(StringUtill.isNull(time)){
		time = "";
	}
	List<InventoryBranchMessage > list = InventoryBranchMessageManager.getCategory(ctype,branchid,time);  
	 
	String str = StringUtill.GetJson(list);
	response.getWriter().write(str);   
	response.getWriter().flush(); 
	response.getWriter().close(); //inventory
}else if("quit".equals(method)){  
	session.invalidate();
	response.sendRedirect("login.jsp");
	return ;   
}else if("updateorder".equals(method)){
	int statues = -1 ;
	String oid = request.getParameter("oid"); 
	String phone1 = request.getParameter("phone1");
	String andate = request.getParameter("andate");
	
	String locations = request.getParameter("locations");
	String message = request.getParameter("message");
	String remark = request.getParameter("remark")==null?"":request.getParameter("remark");
	if(UserManager.checkPermissions(user, Group.dealSend)){
		String POS = request.getParameter("pos");
		String sailId = request.getParameter("sailid"); 
		String check = request.getParameter("check");
		String saledate = request.getParameter("saledate"); 
		statues = OrderManager.updateMessage(phone1,andate,locations,POS,sailId,check,oid,remark,saledate); 
	}else {  
		statues = OrderManager.updateMessage(phone1,andate,locations,oid,remark);  
	} 
	  
	if(!StringUtill.isNull(message)){
	    Message  messa = new Message();  
		messa.setOid(Integer.valueOf(oid)); 
		messa.setMessage(user.getUsername()+":"+message+"\n");     
		MessageManager.save(user,messa);        
	}   
	//response.sendRedirect("dingdanDetail.jsp?id="+oid);
	//response.sendRedirect("");
	
	if(statues == -1){ 
		response.sendRedirect("../jieguo.jsp?type=update");
		//System.out.println(123);  
		session.setAttribute("message", "修改失败");
		 
	}else {
		response.sendRedirect("../jieguo.jsp?type=updated");
		//System.out.println(123);  
		session.setAttribute("message", "修改成功");
	}
	return ;   
}

%>
