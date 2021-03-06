package inventory;


import gift.GiftManager;

import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;

import branch.Branch;
import branch.BranchManager;

import category.Category;
import category.CategoryManager;

import order.OrderManager;
import orderPrint.OrderPrintlnManager;
import orderproduct.OrderProductManager;

import user.User;

import database.DB;

public class InventoryManager {
	protected static Log logger = LogFactory.getLog(InventoryManager.class);
	
	public static List<Inventory> getCategory() { 
		List<Inventory> categorys = new ArrayList<Inventory>();
		Connection conn = DB.getConn();
		String sql = "select * from inventory "; 
		Statement stmt = DB.getStatement(conn);
		ResultSet rs = DB.getResultSet(stmt, sql);
		try {
			while (rs.next()) {
				Inventory u = InventoryManager.getCategoryFromRs(rs);
				categorys.add(u);
			}
		} catch (SQLException e) {
			logger.error(e);
		} finally {
			DB.close(rs);
			DB.close(stmt);
			DB.close(conn);
		} 
		logger.info(categorys.size());
		return categorys;
	}
	

	public static boolean save(User user,Inventory order) {
	     boolean flag  = false ; 
	     
	     Map<Integer,Branch> branchmap = BranchManager.getNameMap();
	     List<String> sqls = new ArrayList<String>(); 
         int instatues = 0 ; 
         int outstatues = 0 ; 
		 int maxid;  
		
		 Inventory oldorder = InventoryManager.getInventoryID(user, order.getId());
		  
		 if(oldorder != null){ 
			 maxid = oldorder.getId();    
			 delete(maxid);
		 }else {   
			 oldorder = InventoryManager.getMaxOrder();
			 if(oldorder == null){
				 maxid = 1 ;
			 }else { 
				 maxid = oldorder.getId()+1;     
			 }
			 
		 }
		 

		if(maxid == 0){ 
			maxid = 1 ;
		}    
	
		
		List<String> sqlp = InventoryMessageManager.save(maxid, order);
	    
		 
	    sqls.addAll(sqlp);  
	    
	    /*if(branchmap != null){
			   Branch branch = branchmap.get(order.getOutbranchid());
		       if(branch != null){
		    	   if(user.getBranch().equals(branch.getLocateName())){
		    		   outstatues =1 ;
		    	   } 
		       } 
		       branch = branchmap.get(order.getInbranchid());
		       if(branch != null){
		    	   if(user.getBranch().equals(branch.getLocateName())){
		    		   instatues =1 ;
		    	   }
		    	   
		       } 
		   }*/
    
	    String sql = "insert into  inventory ( id ,uid , intime ,chekid, inbranchid, outbranchid" +
				", remark,outstatues,instatues) values "+  
				"( "+maxid+", '"+order.getUid()+"', '"+order.getIntime()+"', '"+order.getChekid()+"', '"+order.getInbranchid()+"', '" 
	    		+order.getOutbranchid()+"', '"+order.getRemark()+"',"+outstatues+","+instatues+")";     
	    sqls.add(sql);
	    
	    logger.info(sql);         
	    Connection conn = DB.getConn();   
		  
	    Statement sm = null;  
       try {   
           // 事务开始  
          logger.info("事物处理开始") ;
           conn.setAutoCommit(false);   // 设置连接不自动提交，即用该连接进行的操作都不更新到数据库  
            sm = conn.createStatement(); // 创建Statement对象  
            Object[] strsqls = sqls.toArray();
      logger.info(strsqls.toString());
           //依次执行传入的SQL语句      
           for (int i = 0; i < strsqls.length; i++) {  
               sm.execute((String)strsqls[i]);// 执行添加事物的语句  
           }  
           logger.info("提交事务处理！");  
              
           conn.commit();   // 提交给数据库处理  
              
           logger.info("事务处理结束！");  
           // 事务结束   
            flag = true ;   
       //捕获执行SQL语句组中的异常      
       } catch (SQLException e) {  
           try {   
               logger.info("事务执行失败，进行回滚！\n",e);  
                conn.rollback(); // 若前面某条语句出现异常时，进行回滚，取消前面执行的所有操作  
           } catch (SQLException e1) {  
               logger.info(e);
           }  
       } finally {   
           try {
				sm.close();
			} catch (SQLException e) {
				e.printStackTrace();
			}  
       }  
       
		return flag ; 

	}
	
	
	public static Inventory getMaxOrder(){
	    int id = 1 ;
	    Inventory order = null;
	    Connection conn = DB.getConn();
		Statement stmt = DB.getStatement(conn);
		//  select top 1 * from table order by id desc 
		// select * from table where id in (select max(id) from table)
		String  sql = "select * from inventory where id in (select max(id) from inventory)" ;
		ResultSet rs = DB.getResultSet(stmt, sql);
		try { 
			while (rs.next()) { 
				order = InventoryManager.getCategoryFromRs(rs);
				logger.info(id);
			}
		} catch (SQLException e) {
			e.printStackTrace();
		} finally {
			DB.close(stmt);
			DB.close(rs);
			DB.close(conn);
		 }
		return order; 

  }
	
	public static boolean delete(int id) {
		   
	    boolean flag = false;
	    List<String> listsqls = new ArrayList<String>();
		
		Connection conn = DB.getConn();
  
		String sqlp = InventoryMessageManager.delete(id);
       
          
        String sql = "delete from inventory where id = " + id;
        listsqls.add(sqlp); 
        
        listsqls.add(sql); 
		 
		if (listsqls.size() == 0) {  
            return false;   
        }      
        Statement sm = null;  
        try {  
            // 事务开始  
           logger.info("事物处理开始") ;
            conn.setAutoCommit(false);   // 设置连接不自动提交，即用该连接进行的操作都不更新到数据库  
            sm = conn.createStatement(); // 创建Statement对象  
            
             Object[] sqls = listsqls.toArray() ;
            //依次执行传入的SQL语句  
            for (int i = 0; i < sqls.length; i++) {  
                sm.execute((String)sqls[i]);// 执行添加事物的语句  
            }   
            logger.info("提交事务处理！");  
               
            conn.commit();   // 提交给数据库处理  
               
            logger.info("事务处理结束！");  
            // 事务结束  
             flag = true ;   
        //捕获执行SQL语句组中的异常      
        } catch (SQLException e) {  
            try {   
                logger.info("事务执行失败，进行回滚！\n");  
                conn.rollback(); // 若前面某条语句出现异常时，进行回滚，取消前面执行的所有操作  
            } catch (SQLException e1) {  
                e1.printStackTrace();  
            }  
        } finally {  
            try {
				sm.close();
			} catch (SQLException e) {
				e.printStackTrace();
			}  
        }  
		return flag ;
	}
	
	
	
	public static Inventory getInventoryID(User user ,int id){
		   
		Inventory orders = null;   
		   String sql = "";   
			   sql = "select * from  inventory where id = "+ id ;
	logger.info(sql); 
			    Connection conn = DB.getConn();
				Statement stmt = DB.getStatement(conn);
				ResultSet rs = DB.getResultSet(stmt, sql);
				try {  
					while (rs.next()) {  
						orders = getCategoryFromRs(rs); 
						List<InventoryMessage> listm =  InventoryMessageManager.getInventoryID(user,id); 
					    orders.setInventory(listm); 
					} 
				} catch (SQLException e) {
					e.printStackTrace();
				} finally {
					DB.close(stmt);
					DB.close(rs);
					DB.close(conn);
				 }
				return orders;
		 }
	
	
	
	
	
	
	private static Inventory getCategoryFromRs(ResultSet rs){
		Inventory c = new Inventory(); 
		try {  
			c.setId(rs.getInt("id")); 
			c.setRemark(rs.getString("remark")); 
			c.setChekid(rs.getInt("chekid"));
			c.setIntime(rs.getString("intime"));
			c.setInbranchid(rs.getInt("inbranchid"));
			c.setOutbranchid(rs.getInt("outbranchid")); 
			c.setOutstatues(rs.getInt("outstatues")); 
			c.setInstatues(rs.getInt("instatues"));     
		} catch (SQLException e) {
			e.printStackTrace();
		}	
		return c ;
	}
}
