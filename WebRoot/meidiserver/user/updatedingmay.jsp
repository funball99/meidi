<%@ page language="java" import="java.util.*,gift.*,orderproduct.*,order.*,branch.*,locate.*,category.*,group.*,user.*,utill.*,product.*;" pageEncoding="UTF-8"  contentType="text/html;charset=utf-8"%>
<%
User user = (User)session.getAttribute("user");
if(!UserManager.checkPermissions(user, Group.sale)){ 
	response.sendRedirect("welcom.jsp");
}

List<Category> list = CategoryManager.getCategory(user,Category.sale); 
String clist = StringUtill.GetJson(list);
     
HashMap<Integer,ArrayList<Product>> map = ProductManager.getProduct();
List<Locate> listl = LocateManager.getLocate();
 
HashMap<String,ArrayList<String>> listt = ProductManager.getProductName();
String plist = StringUtill.GetJson(listt);
 
String id = request.getParameter("id");
Order order = OrderManager.getOrderID(user,Integer.valueOf(id));

List<OrderProduct> listop = OrderProductManager.getOrderStatues(user, Integer.valueOf(id));
 
String listopp = StringUtill.GetJson(listop);
 
List<Gift> listg = GiftManager.getGift(user, Integer.valueOf(id));
String listgg = StringUtill.GetJson(listg);

Branch branch = BranchManager.getLocatebyname(user.getBranch()); 

String  branchmessage = branch.getMessage();


if(StringUtill.isNull( branchmessage)){ 
	 branchmessage = "";
}  
String[] branlist =  branchmessage.split("_");

%>
  
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<meta charset="utf-8">
<meta name="apple-mobile-web-app-capable" content="yes" />

<title>报装单提交页面</title>

<meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1">
<script type="text/javascript" src="../js/jquery-1.7.2.min.js"></script>
<script src="../js/mobiscroll.core-2.6.2.js" type="text/javascript"></script>
<script src="../js/mobiscroll.core-2.6.2-zh.js" type="text/javascript"></script>
<link href="../css/mobiscroll.core-2.6.2.css" rel="stylesheet" type="text/css" />
<script src="../js/mobiscroll.datetime-2.6.2.js" type="text/javascript"></script>
<script src="../js/mobiscroll.android-ics-2.6.2.js" type="text/javascript"></script> <link href="../css/mobiscroll.android-ics-2.6.2.css" rel="stylesheet" type="text/css" />
<link rel="stylesheet" href="../css/songhuo.css">

<link rel="stylesheet" href="//code.jquery.com/ui/1.10.4/themes/smoothness/jquery-ui.css">
<script src="//code.jquery.com/ui/1.10.4/jquery-ui.js"></script>

<script type="text/javascript">

  var availableTags = '<%=plist%>';
   var jsons =  $.parseJSON(availableTags);
   var cid = "";
   var ids = "";
   var CList = '<%=clist%>';
   var json =  $.parseJSON(CList);
   var row = 1; 
   var rowz = 1; 
   var rows = new Array();
   var rowzs = new Array();
   var andate = new Array();
   var timefirst = true ; 
            
   var listopp = '<%=listopp%>' ;
   var listgg = '<%=listgg%> ';
   var listop =  $.parseJSON(listopp);
   var listg =  $.parseJSON(listgg);
   var branch = new Array();
   var branchmessage = "<%=branchmessage%>";
  
   branch = branchmessage.split("_");
   
   rows.push(0);
    
   $(document).ready(function(){
	initTime();
	if($.inArray("pos", branch) != -1){
		initpos();
	}  
	initphone();  
	initproduct();
	init();
   }); 
    
   function init(){
		  
	   if(listop != null && listop != "" && listop != "null"){
		   var flag = true ;

		   $("#dingma_no").css("display","block");
		   
		   for(var i=0;i<listop.length;i++){
			   var listo = listop[i];
			   if(1 == listo.statues){			   
				   $("#dingma").css("display","block");
				   $("#dingmatype").val(listo.saleType);
				  // alert($("#ordercategory0").get(0));
				 // alert(listo.categoryId);
				 //  alert($("#ordercategory0 #"+listo.categoryId));
				// alert($("#dingmaordercategory #"+listo.categoryId));
				   $("#dingmaordercategory #"+listo.categoryId).attr("selected","selected");
				   $("#dingmaproductNum").val(listo.count);
				  $("#dingmachek").attr("checked","checked");
				 //  types = listo.categoryId; 				   
			   }
		   }

			  for(var i=0;i<listop.length;i++){
				  var listo = listop[i];
				  if(0 == listo.statues){
					   if(flag){   
						$("#ordertype0").val(listo.sendType);
						$("#orderproductNum0").val(listo.count);
						//alert(listo.categoryId);
						//alert($("#ordercategory0 #33").attr("selected"));
						$("select[id='ordercategory0'] option[id='33']").attr("selected","selected");
						//$("#ordercategory0 #"+listo.categoryId).attr("selected","selected"); 
					    flag = false ;
					   }else {
						   addrow(listo); 
					   }

			   } 
	   }
	   
	   }
	   //listgg
	   if(listgg != null && listgg != "" && listgg != "null"){
		 // alert(listg.length);
		   for(var i=0;i<listg.length;i++){
			   var gift = listg[i];
			    addrowZ(gift);
			   
		   }
	   }   
   }
   
   
   function initproductSerch(str,str2){ 
	    cid = $(str).val();
		$(str2).autocomplete({
			 source: jsons[cid]
		    });

		$(str).change(function(){
			$(str2).val("");
			cid = $(str).val();
			$(str2).autocomplete({
				 source: jsons[cid]
			    });	
			var time ;
			
			for(var i=0;i<json.length;i++){
         	   var jo = json[i];
         	   if(jo.id == cid){
         		   time = jo.time ;
         	   }
			}
			
			if(timefirst){
				 $("#andates").append(time); 
				 timefirst = false ;
			}
			
			 var timeold = $("#andates").html();
			 if(time<timeold){
				 $("#andates").html("");
				 $("#andates").append(time); 
			 }
			 
			}) ;
       }  
   // 大 返回true 
   function compare(andate,str2){
	  // alert(0*365);
	 //  alert("andate"+andate);
	 //  alert(str2);
	   var Astr1 = new Array();
	  // var Astr2 = new Array();
	   Astr1 = andate.split("-");
	  // Astr2 = str2.split("-");
	   var date = new Date();
	   var year = date.getFullYear();
	   var month = date.getMonth()+1;
	 
	   var day = date.getDate();
	 
	   if((Astr1[0]-year)*365+(Astr1[1]-month)*30+(Astr1[2]-day)*1 > str2){
		   return true ;
	   }
	  return false ;
   }
   
   function compareBeifen(){
	   var Astr1 = new Array();
	   var Astr2 = new Array();
	   Astr1 = str1.split("-");
	   Astr2 = str2.split("-");
	   if(Astr1[0] >Astr2[0]){
		   return true ;
	   }else if(Astr1[0] == Astr2[0] && Astr1[1] >Astr2[1]){
		   return true ;
	   }else if(Astr1[0] == Astr2[0] && Astr1[1] == Astr2[1] && Astr1[2] > Astr2[2]){
		   return true ;
	   }
	  return false ;  
   }
   
   function initPhone(){
	   $('#phone1').blur(function (){
			var mes = $('#phone1').val();
			 checkMessage("#phone1",mes);
		});
   }
     
   function initTime(){ 
	   var opt = { };
	    opt.date = {preset : 'date'};
		$('#serviceDate').scroller('destroy').scroller($.extend(opt['date'], 
		{ theme: 'android-ics light', mode: 'scroller', display: 'modal',lang: 'zh' ,startYear:'1980',endYear:'2020',maxDate: new Date()}));
		var opt2 = { };   
	    opt2.date = {preset : 'date'};
		$('#serviceDate2').scroller('destroy').scroller($.extend(opt2['date'], 
		{ theme: 'android-ics light', mode: 'scroller', display: 'modal',lang: 'zh' ,startYear:new Date(),endYear:'2020',minDate: new Date()}));
		var ids = ($(this).children('option:selected').val());
   }
 
   function initpos(){
	   $("#pos").focus(function(){
		    $("#pos").css("background-color","#FFFFCC");
		  });
		  $("#pos").blur(function(){
		    $("#pos").css("background-color","#D6D6FF");
		    var pos = $("#pos").val(); 
		    $.ajax({ 
		        type:"post", 
		         url:"server.jsp",
		         //data:"method=list_pic&page="+pageCount,
		         data:"method=pos&name="+pos,
		         dataType: "",  
		         success: function (data) {
		        	 if("true" == data){ 
		        		 var question = confirm("pos已存在单据有可能录重？，是否继续?");	
		        			if (question == "0"){   
		        				$("#pos").focus();
		        				return false ;
		        			}  
		        	 }  
		           },  
		          error: function (XMLHttpRequest, textStatus, errorThrown) { 
		        	  return false ;
		            } 
		           }); 
		    
		    
		    
		    
		  });  
    }
   
   
 function initphone(){ 
	   $("#phone1").focus(function(){
		    $("#phone1").css("background-color","#FFFFCC");
		  });
		  $("#phone1").blur(function(){
		    $("#phone1").css("background-color","#D6D6FF");
		    var phone1 = $("#phone1").val(); 
		    alert(phone1);
		    $.ajax({ 
		        type:"post",  
		         url:"server.jsp",  
		         //data:"method=list_pic&page="+pageCount,
		         data:"method=phone1&name="+phone1,
		         dataType: "",  
		         success: function (data) {
		        	 if("true" == data){ 
		        		 var question = confirm("顾客电话相同单据有可能录重，是否继续?");	
		        			if (question == "0"){   
		        				//$("#phone1").focus(); 
		        				window.location.href="order.jsp";
		        				return false ;
		        			}else {  
		        				$("#remark").val("1"); 
		        			}  
		        	 }  
		           },  
		          error: function (XMLHttpRequest, textStatus, errorThrown) { 
		        	  return false ;
		            } 
		           }); 
		    
		    
		    
		    
		  });  
}
 function initAndate(str,cid){
	   
		//alert(cid);
		for(var i=0;i<json.length;i++){
 	   var jo = json[i];
 	   if(jo.id == cid){
 		 var time = jo.time ;
 	//	 alert(time);
 		 $(str).html("");
			 $(str).append(time); 
 	   }
		}	
}
 
 function initproduct(){
		
	 initproductSerch("#ordercategory0","#ordertype0","#andate0"); 
	 initproductSerch("#dingmaordercategory","#dingmatype","#dingmaandate");
	 
	  var cid = $("#ordercategory0").val();
      initAndate("#andate0",cid);
      
		  $('input:radio').change(function() {
			  $("#dingma_c").css("display","block");
			  $("#dingma_no").css("display","block");
			
			     if(this.checked){
			    	 var a = $(this).val();
			    	 if(1==a){ 
			    		 $("#dingma").css("display","block");	    		   
			    	 }else { 	    		 
			    		 $("#dingma").css("display","none"); 
			    	 } 	  
			 }
	      }) ;  
      } 
 
 
    function deletegifts(str,str2){
    	$(str).empty();
	    rowzs.splice($.inArray(str2,rowzs),1);	   
     }
    
    function deletes(str,str2){
    	$(str).empty();
	    rows.splice($.inArray(str2,rows),1);
     }
 
 function addrow(listo){
	
	var display = "";
    rows.push(row);
	var yellow = "";
	if(row%2 == 0){
		yellow = "#fff"; 
	}
	
	var type = listo.sendType == null || listo.sendType == undefined ? "":listo.sendType;
	var count = listo.count == null || listo.count == undefined ? 1:listo.count;
	
	var json =  $.parseJSON(CList);
	var str = "";
	    str += '<div id="produc'+row+'" name="produc">'+
	           '<input type="hidden" name="product" value="'+row+'"/>'+
	    	   '<table style="width:100%;background-color:'+yellow+'">'+
               ' <tr>' +
               '<td width="25%" class="center">送货名称<span style="color:red">*</span></td>'+
               '<td width="50%" class="center"><select class = "category" name="ordercategory'+row+'"  id="ordercategory'+row+'"  style="width:95% ">';
               for(var i=0;i<json.length;i++){
            	   var ckeck = "";
            	   var jo = json[i];  
            	   if(jo.id == listo.categoryId){
            		   str += '<option value='+jo.id+'  selected="selected" >'+jo.name+'</option>';
            	   }else {
            		   str += '<option value='+jo.id+'>'+jo.name+'</option>'; 
            	   }
            	   
            	   
               }
               str += '</select> '+
               ' </td>'+
               '<td width="10%" class="center" id="andate'+row+'"></td> '+
               '<td width="5%" class="center" >天</td>' +
               '<td width="15%" class="center"><input type="button"   color= "red" name="" value="删除" onclick="deletes(produc'+row+','+row+')"/></td>'+
                ' </tr>' +
               '</table>'+
               '<table style="background-color:'+yellow+'">'+
               ' <tr>'+
               ' <td width="25%" class="center">送货型号<span style="color:red">*</span></td> '+
               ' <td width="35%" class=""><input type="text"  id="ordertype'+row+'" name="ordertype'+row+'" value="'+type+'" style="width:90% " onclick="serch(type'+row+')"/><div id="aotu'+row+'"></div></td> ' +
               ' <td width="10%" class="center">送货数量</td> '+ 
               ' <td width="10%" class=""><input type="text"  id="orderproductNum'+row+'" name="orderproductNum'+row+'" value="'+count+'" style="width:50%"/></td> '+
               ' <td width="10%" class="center"><input type="button"   name="" value="+" onclick="add(orderproductNum'+row+')"/></td> '+ 
               ' <td width="10%" class="center"><input type="button"   name="" value="-" onclick="subtraction(orderproductNum'+row+') " /></td> '+ 
               ' </tr>'+
               '<tr></tr>'+
               '<table>'+
               ' <hr>' +
                '</div>'; 
                
        $("#productDIV").append(str);
        initproductSerch("#ordercategory"+row,"#ordertype"+row);
        var cid = $("#ordercategory"+row).val();
        initAndate("#andate"+row,cid);
        row++; 
        }	
 
        function addrowZ(listo){
        	var sele = "";
        	var name = listo.name == null || listo.name == undefined ? "":listo.name;
        	var count = listo.count == null || listo.count == undefined ? 1:listo.count;
        	var type = listo.statues == null || listo.statues == undefined ? "":listo.statues;
        	if(type == 0){
        		sele = 'selected="selected"'; 
        	}
        	rowzs.push(rowz);
        	var yellow = "";
        	if(rowz%2 == 0){
        		yellow = "#fff";
        	}
        	
        	var str = '<div id=gift'+rowz+'><input type="hidden" name="gift" value="'+rowz+'"/>';

        	    str += '<table style="background-color:'+yellow+'">'+
        	    '<tr>'+
        	   ' <td width="25%" class="center">赠品</td>'+
        	    '<td width="35%" class=""> <input type="text"  id="giftT'+rowz+'" value="'+name+'" name="giftT'+rowz+'" style="width:90% " value=""/> </td>'+
        	   ' <td width="10%" class="center">数量</td>'+
        	   ' <td width="10%" class=""><input type="text"  id="productNn'+rowz+'" value = "'+count+'" name="giftCount'+rowz+'" value="1" style="width:50%"/></td>'+
        	   ' <td width="10%" class="center"><input type="button"   name="" value="+" onclick="add(productNn'+rowz+')" /></td>'+
        	   ' <td width="10%" class="center"><input type="button"   name="" value="-" onclick="subtraction(productNn'+rowz+')" /></td>'+
        	  ' </tr>'+
        	  '  </table>'+
        	 '  <table style="width:100%;background-color:'+yellow+'">'+
        	 ' <tr>'+
        	  '  <td width="25%" class="center">赠品状态</td>'+
        	  '  <td width="50%" class="">'+
        	  '  <select  name="giftsta'+rowz+'"   style="width:90%; ">'+
        	  '  	<option value="1">已自提</option>'+
        	   ' 	<option value="0" '+sele+'>需配送</option>'+
        	  '  </select>'+

        	   ' </td>'+
        	   ' <td width="25%" class="center"><input type="button"   color= "red" name="" value="删除" onclick="deletegifts(gift'+rowz+')"/></td>'+
        	   '</tr>'+

        	'</table>';
	        $("#zengpDIV").append(str); 
	        rowz++;
	 }	
  
  function add(str){
	 var id = $(str).val();
     var nid = id*1 + 1;
	 $(str).val(nid);
 }
 
 function subtraction(str){
	 var id = $(str).val();
	 
	 if(id*1<=1){
		 $(str).val(1); 
		 return ;
	 }
     var nid = id*1 - 1;
	 $(str).val(nid);
 }
 
 function checkNull(str){
	 if(str == "" || tr == null || str == "null"){
		 return true;
	 }
 }

 function checkedd(){

	 //return true ;
	 var saledate = $("#serviceDate").val();
	 var andate = $("#serviceDate2").val();
	 var pos = $("#pos").val();
	 var sailId = $("#sailId").val();
	 var check = $("#check").val();
	 var username = $("#username").val();
	 var phone1 = $("#phone1").val();
	 var phone2 = $("#phone2").val();
	 var locations = $("#locations").val();
	 var remark = $("#remark").val();
	 var radio = $('input:radio[name="Statues"]:checked').val();
	
     if(saledate == "" || saledate == null || saledate == "null"){
		 alert("开票日期不能为空");
		 return false;
	 }
	  
	 if($.inArray("pos", branch) != -1){
		 if(pos == "" || pos == null || pos == "null"){
			 alert("pos单号不能为空");
			 return false;
		 }
     } 
     
     if($.inArray("sailId", branch) != -1){
		 if(sailId == "" || sailId == null || sailId == "null"){
			 alert("OMS订单号不能为空");
			 return false;
		 }
     }
       
     if($.inArray("check", branch) != -1){
		 if(check == "" || check == null || check == "null"){
			 alert("校验码不能为空");
			 return false;
		 } 
     }
 
	 if("1"== radio){ 
		 var dingmatype = $("#dingmatype").val();
		 if(dingmatype == "" || dingmatype == null || dingmatype == "null"){
			 alert("请选择是否顶码销售");  
			 return false;
		 }
	 } 
	    
	 for(var i=0;i<rows.length;i++){
		 var str = $("#ordertype"+rows[i]).val();
		 if(str == "" || str == null || str == "null"){
			 alert("送货型号不能为空");
			 return false; 
		 }else {
			 var flag = true ;
			 for(var j=0;j<json.length;j++){
	         	   var jo = json[j];
	         	   var array = jsons[jo.id];
	         	  if(array != "" && array != null &&  array != "null" && array != undefined && array != "undefined"){
		         	   for(var k=0;k<array.length;k++){
		         		   
		         		   if(str == array[k]){
		         			   flag = false  ;
		         		   }
		         	   }
		         	   }
				}
			 if(flag){
				 alert("系统不存在此型号"+str);
				 return false ;
			 }
		 }
	 }
	 
	 for(var i=0;i<rowzs.length;i++){
		// alert(rowzs[i]);
		 var str = $("#giftT"+rowzs[i]).val();
		 if(str == "" || str == null || str == "null"){
			 alert("赠品不能为空");
			 return false;
		 }
	 }
	 
	 if(andate == "" || andate == null || andate == "null"){
		 alert("预约安装时间不能为空");
		 return false;
	 }else {
		 var timeold = 0;
		 for(var i=0;i<rows.length;i++){
			
			 if(i == 0){
				timeold = $("#andate"+rows[i])[0].innerText*1;
			 }
			
			 var str = $("#andate"+rows[i])[0].innerText*1;
			// alert(str);
			 if(str < timeold){
				timeold = str ;
			 } 
		 }
		 if(compare(andate,timeold)){
			 alert("预约安装日期超过期限");
			 return false ; 
		 }
	 }
	 
	 if(username == "" || username == null || username == "null"){
		 alert("姓名不能为空");
		 return false;
	 }
	 
	 if(phone1 == "" || phone1 == null || phone1 == "null"){
		 alert("电话不能为空");
		 return false;
	 }
	 else {
	    var filter = /^1[3|4|5|8][0-9]\d{8}$/;  
	    var isPhone=/^((0\d{2,3})-)?(\d{7,8})(-(\d{3,}))?$/;
		 if(!filter.test(phone1) || !isPhone.test(phone1)){
			 alert("请填写正确的手机号码或电话");    
			 return false;
		 }
	 } 

	 if(locations == "" || locations == null || locations == "null"){
		 alert("详细地址不能为空");
		 return false;
	 }
	 
	 $('input[name="permission"]:checked').each(function(){ 
		    alert($(this).val());  
	 });
	 
	 $("#submit").css("display","none"); 
	 
	 return true ;
 }
 
</script>


</head>
<body>
<div class="s_main">
<jsp:include flush="true" page="head.jsp">
  <jsp:param name="dmsn" value="" /> 
  </jsp:include>
<div class="s_main_tit"><span class="qiangdan"><a href="serch_list.jsp">订单查询</a></span><span class="qiangdan"><a href="server.jsp?method=quit">退出</a></span></div>
<form action="OrderServlet"  method ="post"  id="form"  onsubmit="return checkedd()" >
<!--  头 单种类  --> 
<input type="hidden" name="gift" value="0"/>
<input type="hidden" name="product" value="0"/>  
 <input type="hidden" id="remark" name="phoneRemark" value="0"/>
 
<input type="hidden" name="orderid" value="<%=order.getId() %>"/> 
<div class="s_main_tit">销售报单<span class="qiangdan"></span></div>
<div class="s_main_tit">门店:<span class="qian"><%=user.getBranch() %></span></div>  
<!--  订单详情  -->  
<div class="s_dan_box"> </div>
    
<table style="width:100% ">
  
  <tr>  
    <td width="25%" class="center">开票日期<span style="color:red">*</span></td>
    <td width="50%" class=""><input class="date" type="text" name="saledate" value="<%=order.getSaleTime() %>" placeholder="必填"  id="serviceDate"  readonly="readonly" style="width:90% "></input>   </td>
    <td width="25%" class="center"></td>
  </tr>
  
  <tr> 
    <td width="25%" class="center">pos(厂送)单号 <span style="color:red">*</span></td>
    <td width="50%" class=""> <input type="text"  id="pos" name="POS" value="<%=order.getPos() %>" style="width:90% "/></td>
    <td width="25%" class="center"> </td>
   </tr>
   
  <tr>
    <td width="25%" class="center">OMS订单号 <span style="color:red">*</span></td> 
    <td width="50%" class=""><input type="text"  id="sailId" value="<%=order.getSailId() %>" name="sailId" style="width:90% " /></td>
    <td width="25%" class="center"></td>
  </tr>
  
  <tr>
    <td width="25%" class="center">效验码<span style="color:red">*</span></td>
    <td width="50%" class=""> <input type="text"  id="check" name="check" value="<%=order.getCheck() %>" style="width:90% " /></td>
    <td width="25%"></td>
  </tr>
  <tr>
    <td width="25%" class="center">顶码销售<span style="color:red">*</span></td>
    <td width="50%" class="">  是
		<input type="radio"  name="Statues" value="1" id="dingmachek"/>
		&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
		否
		<input type="radio" name="Statues" checked="checked" value="0" /></td>
    <td width="25%"> </td>
  </tr>
  </table>
  
  <div id = "productDIV" >
  <div id="dingma"  style= "display:none;">
   <hr>
  <table style="width:100%;background-color:"> 
  <tr>
  <td width="25%" class="center">票面名称<span style="color:red">*</span></td>
  <td width="50%" class="center">
  <select class="category" name="dingmaordercategory" id="dingmaordercategory" style="width:95% ">
  
  <%  
  for(int i=0;i<list.size();i++){
	  Category cate = list.get(i);
  %>
    <option value="<%= cate.getId()%>"  id="<%= cate.getId()%>"><%=cate.getName()%></option>
  <%
  }
  %>
    
  </select>  
  </td>
  <td width="10%" class="center" id=""></td>
  <td width="5%" class="center" ></td>  
  <td width="10%" class="center" id="">&nbsp;</td> 
  </tr>

  <tr> 
  <td width="25%" class="center">票面型号<span style="color:red">*</span></td> 
   <td width="35%" class="">
   <input type="text" id="dingmatype" name="dingmatype"  onclick="serch(type1)">
   </td> 
   <td width="10%" class="center">数量</td> 
   <td width="10%" class=""><input type="text" id="dingmaproductNum" name="dingmaproductNum" value="1" style="width:50%"></td>  
   <td width="10%" class="center"><input type="button" name="" value="+" onclick="add(dingmaproductNum)"></td>  
   <td width="10%" class="center"><input type="button" name="" value="-" onclick="subtraction(dingmaproductNum)"></td>  
   </tr>
   </table>
   </div>
   
 <div id="dingma_no"  style= "display:none;">
  <table style="width:100%;background-color:"> 
  <tbody>
  <tr>
  <td width="25%" class="center">送货名称<span style="color:red">*</span></td>
  <td width="50%" class="center">
  <select class="category" name="ordercategory0" id="ordercategory0" style="width:95% ">
  
  <%
  for(int i=0;i<list.size();i++){
	  Category cate = list.get(i);
  %>
    <option value="<%=cate.getId()%>" id="<%=cate.getId()%>"><%=cate.getName()%></option>
  <%
  }
  %>
  
  </select>  
  </td>
  <td width="10%" class="center" id="andate0"></td>
  <td width="5%" class="center" >天</td>  
  <td width="10%" class="center" id="">&nbsp;</td> 
  </tr>
    <tr>
   <td width="25%" class="center">送货型号<span style="color:red">*</span></td> 
   <td width="35%" class="">
   <input type="text" name="ordertype0" id="ordertype0" class="cba"/> 
    </td> 
   <td width="10%" class="center">送货数量</td>  
   <td width="10%" class=""><input type="text" id="orderproductNum0" name="orderproductNum0" value="1" style="width:50%"></td>  
   <td width="10%" class="center"><input type="button" name="" value="+" onclick="add(orderproductNum0)"></td>  
   <td width="10%" class="center"><input type="button" name="" value="-" onclick="subtraction(orderproductNum0) "></td>  
   </tr>
   </table>
    <hr>
   </div>

    
    
   </div>
   
  
  
  
  <div id = "zengpDIV"  >
   
  </div>
   <table style="width:100%;background-color:orange">
     <tr > 
    
    <td width="25%" class=" center"><input type="button"  name="" value="增加赠品" onclick="addrowZ(0)" width="100%"/></td>
    <td width="25%" class="center"></td>
    <td width="25%"><input type="button"  name="" value="增加商品" onclick="addrow(0)" width="100%"/></td>
    <td width="25%" class="center"></td> 
   </tr>
   </table>
   <table style="width:100% ">
   <tr> 
    <td width="25%" class="center">预约安装日期<span style="color:red">*</span></td>
    <td width="45%" class=""><input class="date2" type="text" name="andate" id ="serviceDate2" placeholder="必填"  value="<%=order.getOdate() %>" readonly="readonly" style="width:90% "></input>   </td>
    <td width="25%" class="center" id="andates"></td> 
    <td width="5%"></td>
   </tr>
  <tr> 
    <td width="25%" class="center">顾客姓名<span style="color:red">*</span></td>
    <td width="50%" class=""><input type="text" id="username" name="username" value="<%=order.getUsername() %>" style="width:90%"></input></td>
   <td width="25%" class="center"></td>
   </tr> 
   <tr>
    <td width="25%" class="center">电话<span style="color:red">*</span></td>
    <td width="50%" class=""><input type="text"  id="phone1"  name="phone1" value="<%=order.getPhone1() %>" style="width:90%" /></td>
   <td width="25%" class="center"></td>
   </tr>
  <tr>
    <td width="25%" class="center">电话2</td>
    <td width="25%" class=""><input type="text" style="width:90%;" id="phone2" name="phone2" value="<%=order.getPhone2()==null||order.getPhone2()=="null"?"":order.getPhone2() %>"/></td>
   </tr> 
   
    <tr> 
    <td width="25%" class="center">所在区域<span style="color:red">*</span></td>

    <td width="25%" class=""><select class = "quyu" name="diqu" >
		<%
		 for(int i=0;i<listl.size();i++){
			 Locate lo = listl.get(i);
			 String str = "";
			 if(lo.getLocateName().equals(order.getLocate())){
				 str = "selected = 'selected'";
			 }
			 
			  
		%>	
		 <option value="<%=lo.getLocateName()%>"  <%=str %> ><%=lo.getLocateName()%></option>
		<%
		 } 
		%>
	</select>
	</td>
   </tr>
</table>
   <table style="width:100% ">
  <tr>
    <td width="25%" class="center">详细地址<span style="color:red">*</span></td>
    <td width="75%" class=""><textarea  id="locations" name="locations" ><%=order.getLocateDetail() %></textarea></td>  
   </tr>
  <tr>
    <td width="25%" class="center">备注</td>
    <td width="75%" class=""><textarea  id="remark" name="remark" ><%=order.getRemark() %></textarea></td>
   </tr>
</table> 
 <div id="submit">
 <table style="width:100%;background-color:orange">
  <tr>  
    <td width="100%" class="center"><input type="submit"  value="提  交" /></td>
   </tr>
   </table>
   </div>
 <div class="center"> 
 </div>
</form>
</div>
</body>
</html>