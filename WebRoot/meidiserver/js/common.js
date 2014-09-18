var index = "";//当前焦点的ID//行点击事件，参数
 
function updateClass(obj) { 
	
	 if (obj.id != index) { //点击了非当前焦点的行
         obj.className = "asc_enable"; //将当前焦点的行设为红色
         if(index != null && index != ""){
        	 document.getElementById(index).className = "asc";//原先的当前焦点行设为灰色
         }
        
         //改变当前焦点标识
         index = obj.id;
     }

}
 
var pre_scrollTop=0;//滚动条事件之前文档滚动高度
var pre_scrollLeft=0;//滚动条事件之前文档滚动宽度
var obj_th;
window.onload =function () {
    pre_scrollTop=(document.documentElement.scrollTop || document.body.scrollTop);
    pre_scrollLeft=(document.documentElement.scrollLeft || document.body.scrollTop);
    obj_th=document.getElementById("th");
};