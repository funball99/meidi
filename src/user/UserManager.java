package user;

import group.*;

import java.io.UnsupportedEncodingException;
import java.net.URLEncoder; 
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;

import utill.StringUtill;

import category.Category;
import category.CategoryManager;
 
import database.DB;
    
public class UserManager {  
	protected static Log logger = LogFactory.getLog(UserManager .class);
	//  验证是否有相同的用户名
	public static boolean getName(String c){
    	boolean flag = false ; 
		Connection conn = DB.getConn();
		String sql = "select * from mduser where statues != 2 and username = '"+ c+ "'";
logger.info(sql);   
		Statement stmt = DB.getStatement(conn);
		ResultSet rs = DB.getResultSet(stmt, sql);
		try { 
			while (rs.next()) {
				flag = true ;
			}
		} catch (SQLException e) {
			e.printStackTrace();
		} finally {
			DB.close(rs);
			DB.close(stmt);
			DB.close(conn);
		}	
    	return flag;
    }
	
	//  根据id验证职工是否存在
	 public static boolean getid(int id){
		   boolean flag = false ;
		   if(0 == id ){
			   return flag ;
		   }
		    Connection conn = DB.getConn();
			Statement stmt = DB.getStatement(conn);
			String  sql = "select id from mduser where id = " + id ;
			ResultSet rs = DB.getResultSet(stmt, sql);
			try {
				while (rs.next()) {
					flag = true ;
				}
			} catch (SQLException e) {
				e.printStackTrace();
			} finally {
				DB.close(stmt);
				DB.close(rs);
				DB.close(conn);
			 }
			return flag;

	   }
	 
	 // 保存职工
	public static boolean save(User user) {
		boolean flag = false ;
		if(UserManager.getName(user.getUsername())){
			return flag; 
		}
	
		String sql = ""; 
		User old = UserManager.getUser(user);
		if(old != null){     
			UserManager.delete(old.getId());   
			sql = "insert into mduser (id, username,nickusername,userpassword, entryTime,branch,positions,usertype,products,phone,charge,statues,chargeid,location) VALUES ("+old.getId()+",?,?,?,?,?,?,?,null,?,?,?,?,?)";
		}else {
			sql = "insert into mduser (id, username,nickusername,userpassword, entryTime,branch,positions,usertype,products,phone,charge,statues,chargeid,location) VALUES (null,?,?,?,?,?,?,?,null,?,?,?,?,?)";	
		}
		Connection conn = DB.getConn();

		PreparedStatement pstmt = DB.prepare(conn, sql);
		try {
			pstmt.setString(1, user.getUsername());
			pstmt.setString(2, user.getNickusername());
			pstmt.setString(3, user.getUserpassword());
			pstmt.setString(4, user.getEntryTime());
			pstmt.setString(5, user.getBranch());
			pstmt.setString(6, user.getPositions());
			pstmt.setInt(7, user.getUsertype());
			pstmt.setString(8, user.getPhone());
			pstmt.setString(9, user.getCharge());
			pstmt.setInt(10, user.getStatues());
			pstmt.setInt(11, user.getChargeid()); 
			pstmt.setString(12, user.getLocation());   
logger.info(sql);  
			int count = pstmt.executeUpdate();
			if(count > 0){
				flag = true ;
			}
		} catch (SQLException e) {
			e.printStackTrace();
		} finally {
			DB.close(pstmt);
			DB.close(conn);
		}
    return flag ;  
	}
    // 更新员工
	public static boolean update(User user) {
		String sql ;
		
		if(UserManager.getid(user.getId())){
			UserManager.delete(user.getId());
			sql = "insert into mduser (id, username,nickusername,userpassword, entryTime,branch,positions,usertype,products,phone,charge,statues,chargeid) VALUES ("+user.getId()+",?,?,?,?,?,?,?,null,?,?,?,?)";
		}else {
			sql = "insert into mduser (id, username,nickusername,userpassword, entryTime,branch,positions,usertype,products,phone,charge,statues,chargeid) VALUES (null,?,?,?,?,?,?,?,null,?,?,?,?)";	
		}
		Connection conn = DB.getConn();
		
		PreparedStatement pstmt = DB.prepare(conn, sql);
		try {
			pstmt.setString(1, user.getUsername());
			pstmt.setString(2, user.getNickusername());
			pstmt.setString(3, user.getUserpassword());
			pstmt.setString(4, user.getEntryTime());
			pstmt.setString(5, user.getBranch());
			pstmt.setString(6, user.getPositions());
			pstmt.setInt(7, user.getUsertype());
			pstmt.setString(8, user.getPhone());
			pstmt.setString(9, user.getCharge()); 
			pstmt.setInt(10, user.getStatues()); 
			pstmt.setInt(11, user.getChargeid());   
logger.info(pstmt);   
			pstmt.executeUpdate();
		} catch (SQLException e) {
			e.printStackTrace();
		} finally {
			DB.close(pstmt);
			DB.close(conn);
		}
    return true ;
	}
	// 获取职工的权限
	public static String[] getPermission(User user){
		
		String sql = "select permissions from mdgroup where  id = '" + user.getUsertype()+"';";
		
		System.out.println(sql);
		Connection conn = DB.getConn();
		String[] Permissions = null ;
		Statement stmt = DB.getStatement(conn);
		ResultSet rs = DB.getResultSet(stmt, sql);
		try {
			while (rs.next()) {
				String permissions = rs.getString("permissions");
				Permissions = permissions.split("_");
				System.out.println(2);
			}
		} catch (SQLException e) {
			e.printStackTrace();
		}
		return Permissions;
	}
	// 获取职工的产品权限
		public static String[] getProducts(User user){
			
			String sql = "select products from mdgroup where  id = '" + user.getUsertype()+"';";
			
	logger.info(sql);
			Connection conn = DB.getConn();
			String[] Permissions = null ;
			Statement stmt = DB.getStatement(conn);
			ResultSet rs = DB.getResultSet(stmt, sql);
			try {
				while (rs.next()) {
					String permissions = rs.getString("products");
					Permissions = permissions.split("_");
logger.info(Permissions);					
				}
			} catch (SQLException e) {
				e.printStackTrace();
			}
			return Permissions;
		}
		
	// 验证职工是否有某种权限
		
	public static boolean checkPermissions(User user , int permissions){
		
		
		
		
		if(Group.tuihuo == permissions){
			permissions = Group.send;
		   }  
		boolean flag = false ;
		Group listg = GroupManager.getGroup(user.getUsertype());
		String[] pe = null ;
		if(listg != null){
			pe = listg.getPermissions().split("_");
		} 
		 if(pe != null){
			 for(int i=0;i<pe.length;i++){
	
				// logger.info(permissions+"***"+pe[i]);
					if(Integer.valueOf(pe[i]) == permissions || Integer.valueOf(pe[i]) == Group.Manger){
						flag = true ;
					}
				} 
		 }
		  
		return  flag ;
	}  
	
	// 获取职工
	public static List<User> getUsers() {
		List<User> users = new ArrayList<User>();
		Connection conn = DB.getConn();
		String sql = "select * from  mduser";
		Statement stmt = DB.getStatement(conn);
		ResultSet rs = DB.getResultSet(stmt, sql);
		try {
			while (rs.next()) {
				User u = UserManager.getUserFromRs(rs);
				users.add(u);
			}
		} catch (SQLException e) {
			e.printStackTrace();
		} finally {
			DB.close(rs);
			DB.close(stmt);
			DB.close(conn);
		}
		return users;
	}
	   
	public static User getUser(User user) {
		User u  = null;
		Connection conn = DB.getConn();
		String sql = "select * from  mduser where username = '"+ user.getUsername() + "' and phone = '" + user.getPhone() + "' and branch = '"+user.getBranch()+"'  and statues = 2";
	logger.info(sql); 	 
		Statement stmt = DB.getStatement(conn);
		ResultSet rs = DB.getResultSet(stmt, sql);
		try {
			while (rs.next()) {
				u = UserManager.getUserFromRs(rs);
				
			}
		} catch (SQLException e) {
			e.printStackTrace();
		} finally {
			DB.close(rs);
			DB.close(stmt);
			DB.close(conn);
		} 
		return u;
	}
	
	// 获取职工
		public static List<User> getUsersNodelete() {
			List<User> users = new ArrayList<User>();
			Connection conn = DB.getConn(); 
			String sql = "select * from  mduser where statues != 2";
			Statement stmt = DB.getStatement(conn);
			ResultSet rs = DB.getResultSet(stmt, sql);
			try {
				while (rs.next()) {
					User u = UserManager.getUserFromRs(rs);
					users.add(u);
				}
			} catch (SQLException e) {
				e.printStackTrace();
			} finally {
				DB.close(rs);
				DB.close(stmt);
				DB.close(conn);
			}
			return users;
		}
		
		// 获取职工
		
				public static List<User> getUsersNodelete(User user) {
					
					List<User> users = new ArrayList<User>();
					Connection conn = DB.getConn();
					String sql = "";
					
					if(UserManager.checkPermissions(user, Group.Manger)){
						sql = "select * from  mduser where statues != 2 order by id desc";
					}else {
						sql = "select * from  mduser where statues != 2 and usertype in (select id from mdgroup where pid = "+user.getUsertype()+") order by id desc";
					}
					//  select id from mdgroup where pid = user.get
					Statement stmt = DB.getStatement(conn);
					ResultSet rs = DB.getResultSet(stmt, sql);
					try {
						while (rs.next()) {
							User u = UserManager.getUserFromRs(rs);
							users.add(u);
						}
					} catch (SQLException e) {
						e.printStackTrace();
					} finally {
						DB.close(rs);
						DB.close(stmt);
						DB.close(conn);
					}
					return users;
				}    
		
              public static List<User> getUserszhuce(User user) {
					
					List<User> users = new ArrayList<User>();
					Connection conn = DB.getConn();
					String sql = "";
					
					if(UserManager.checkPermissions(user, Group.Manger)){
						sql = "select * from  mduser where statues = 0";
					}else {
						sql = "select * from  mduser where statues = 0 and usertype in (select id from mdgroup where pid = "+user.getUsertype()+")";
					}
					//  select id from mdgroup where pid = user.get
					Statement stmt = DB.getStatement(conn);
					ResultSet rs = DB.getResultSet(stmt, sql);
					try {
						while (rs.next()) {
							User u = UserManager.getUserFromRs(rs);
							users.add(u);
						}
					} catch (SQLException e) {
						e.printStackTrace();
					} finally {
						DB.close(rs);
						DB.close(stmt);
						DB.close(conn);
					}
					return users;
				}   

         public static List<User> getUsersNodeleteDown(User user ,int count ) {
					
        	       if(UserManager.checkPermissions(user, Group.Manger)){
        	    	   return null ;
        	       }
        	 
        	 
					List<User> users = new ArrayList<User>();
					Connection conn = DB.getConn();
					
					String str1 = "(select id from mdgroup where pid = "+user.getUsertype()+") "; 
					String str = " (select id from mdgroup where pid in " ;
					
					for(int i = 0 ;i < count ;i ++ ){
						str +=  str1 +")";
						
					}
					
					String sql = "select * from  mduser where statues != 2 and usertype in "+ str +" order by id desc";
					//  select id from mdgroup where pid = user.get
					Statement stmt = DB.getStatement(conn);
					ResultSet rs = DB.getResultSet(stmt, sql);
					logger.info(sql);
					try {
						while (rs.next()) {
							User u = UserManager.getUserFromRs(rs);
							users.add(u);
						}
					} catch (SQLException e) {
						e.printStackTrace();
					} finally {
						DB.close(rs);
						DB.close(stmt);
						DB.close(conn);
					}
					return users;
				}    			
				
	// type 2 为售货员
	public static List<User> getUsers(int type) {
		
		List<Group> listg = GroupManager.getInstance().getListGroupFromPemission(type);
		
		String str = StringUtill.GetSqlInGroup(listg);
		
		List<User> users = new ArrayList<User>();
		Connection conn = DB.getConn();
		String sql = "select * from  mduser where  usertype in " + str + "  and statues = 1 ";
logger.info(sql);		
		Statement stmt = DB.getStatement(conn);
		ResultSet rs = DB.getResultSet(stmt, sql);
		try {
			while (rs.next()) {
				User u= UserManager.getUserFromRs(rs);
				users.add(u);
			}
		} catch (SQLException e) {
			e.printStackTrace();
		} finally {
			DB.close(rs);
			DB.close(stmt);
			DB.close(conn);
		}
		return users;
	}
	 
	// type 2 为售货员  二级配单
		public static List<User> getUsers(User user ,int type) {
			
			//List<Group> listg = GroupManager.getInstance().getListGroupFromPemission(type);
            List<Group> listg = GroupManager.getGroupPeimission(type); 
		
			String str = StringUtill.GetSqlInGroup(listg);
	
			List<User> users = new ArrayList<User>();
			Connection conn = DB.getConn();
			String sql = "";
			 if(UserManager.checkPermissions(user, Group.Manger)){
				 sql = "select * from  mduser where statues = 1  and  usertype in " + str ;
			 }else {
				 sql = "select * from  mduser where statues = 1  and usertype in (select id from mdgroup where pid = "+user.getUsertype()+") and  usertype in " + str ;
			 }
			
		logger.info(sql);	
	
			Statement stmt = DB.getStatement(conn);
			ResultSet rs = DB.getResultSet(stmt, sql);
			try {
				while (rs.next()) {
					User u= UserManager.getUserFromRs(rs);
					users.add(u);
				}
			} catch (SQLException e) {
				e.printStackTrace();
			} finally {
				DB.close(rs);
				DB.close(stmt);
				DB.close(conn);
			}
			return users;
		}
	  
	public static List<User> getUsersZ(int type) {
		List<Group> listg = GroupManager.getInstance().getListGroupFromPemission(type);
		String str = StringUtill.GetSqlInGroup(listg);
		List<User> users = new ArrayList<User>();
		Connection conn = DB.getConn();
		String sql = "select * from  mduser where  statues = 1 and usertype in " + str ;
		Statement stmt = DB.getStatement(conn);
		ResultSet rs = DB.getResultSet(stmt, sql);
		try {
			while (rs.next()) {
				User u= UserManager.getUserFromRs(rs);
				users.add(u);
			}
		} catch (SQLException e) {
			e.printStackTrace();
		} finally {
			DB.close(rs);
			DB.close(stmt);
			DB.close(conn);
		}
		return users;
	}
	
	//  获取主管
	
	public static List<String>  getUsersregist(int type) {
		
		List<String> users = new ArrayList<String>();
		Connection conn = DB.getConn();
                    
		String sql = "select * from  mduser where  statues = 1  and usertype = " + type ;
		  
		Statement stmt = DB.getStatement(conn);
logger.info(sql); 
		ResultSet rs = DB.getResultSet(stmt, sql);  
		try {
			while (rs.next()) {
				User u= UserManager.getUserFromRs(rs);
				  
				users.add(u.getUsername());
			}
		} catch (SQLException e) {
			e.printStackTrace();
		} finally {
			DB.close(rs);
			DB.close(stmt);
			DB.close(conn);
		}
		return users;
	}
	
	// 根据组获取用户
	
	public static List<User> getUsers(String id) { 
		List<User> users = new ArrayList<User>();
		Connection conn = DB.getConn(); 
		String sql = "select * from  mduser where usertype in " +id +" and statues = 1 ";
		Statement stmt = DB.getStatement(conn);
		ResultSet rs = DB.getResultSet(stmt, sql);
		try { 
			while (rs.next()) { 
				User u = UserManager.getUserFromRs(rs);
				users.add(u);
			}
		} catch (SQLException e) {
			e.printStackTrace();
		} finally {
			DB.close(rs);
			DB.close(stmt);
			DB.close(conn);
		}
		return users;
	}
	    
//   获取活动租户  
	public static List<User> getUsersL(String id) { 
	List<User> users = new ArrayList<User>();
	Connection conn = DB.getConn();
	String sql = "select * from  mduser where statues != 2 and usertype = " +id;
	Statement stmt = DB.getStatement(conn);
	ResultSet rs = DB.getResultSet(stmt, sql);
	try {
		while (rs.next()) {
			User u = UserManager.getUserFromRs(rs);
			users.add(u);
		}
	} catch (SQLException e) {
		e.printStackTrace();
	} finally {
		DB.close(rs);
		DB.close(stmt);
		DB.close(conn);
	}
	return users;
}	
   // 根据id获取职工
	public static User getUesrByID(String id) {
		User u = new User();
		Connection conn = DB.getConn();
		String sql = "select * from  mduser where id = " + id;;
		Statement stmt = DB.getStatement(conn);
		ResultSet rs = DB.getResultSet(stmt, sql);
		try {
			while (rs.next()) {
				u = UserManager.getUserFromRs(rs);
			}
		} catch (SQLException e) {
			e.printStackTrace();
		} finally {
			DB.close(rs);
			DB.close(stmt);
			DB.close(conn);
		}
		return u;
	}
	/**
	 * 
	 * @param users
	 * @param pageNo
	 * @param pageSize
	 * @return 总共有多少条记录
	 */
	public static int getUsers(List<User> users, int pageNo, int pageSize) {

		int totalRecords = -1;

		Connection conn = DB.getConn();
		String sql = "select * from mduser limit " + (pageNo - 1) * pageSize
				+ "," + pageSize;
		Statement stmt = DB.getStatement(conn);
		ResultSet rs = DB.getResultSet(stmt, sql);
 
		Statement stmtCount = DB.getStatement(conn);
		ResultSet rsCount = DB.getResultSet(stmtCount,
				"select count(*) from user");
		try {
			rsCount.next();
			totalRecords = rsCount.getInt(1);

			while (rs.next()) {
				User u = new User();
				u.setId(rs.getInt("id"));
				//u.setName(rs.getString("name"));
				//u.setPassword(rs.getString("password"));
				//u.setType(rs.getInt("type"));
				u.setProducts(rs.getString("products"));
				users.add(u);
			}
		} catch (SQLException e) {
			e.printStackTrace();
		} finally {
			DB.close(rsCount);
			DB.close(stmtCount);
			DB.close(rs);
			DB.close(stmt);
			DB.close(conn);
		}
		return totalRecords;
	}
   // 删除职工
	public static boolean delete(int id) {
		boolean b = false;
		Connection conn = DB.getConn();
		String sql = "delete from mduser where id = " + id;
		Statement stmt = DB.getStatement(conn);
		try {
			DB.executeUpdate(stmt, sql);
			b = true;
		} finally {
			DB.close(stmt);
			DB.close(conn);
		}
		return b;
	}
    // 获取每种产品对应的配单元
	
	   public static HashMap<Integer,User> getMap(){
		   HashMap<Integer,User> users = new HashMap<Integer,User>();
			Connection conn = DB.getConn();
			String sql = "select * from  mduser";
			Statement stmt = DB.getStatement(conn);
			ResultSet rs = DB.getResultSet(stmt, sql);
			try {
				while (rs.next()) {
					User u = UserManager.getUserFromRs(rs);
					users.put(rs.getInt("id"), u);
				}
			} catch (SQLException e) {
				e.printStackTrace();
			} finally {
				DB.close(rs);
				DB.close(stmt);
				DB.close(conn);
			}
			return users;
	   }
	   
	   // 
	   public static HashMap<Integer,User> getMap(int type){
		    
		   List<Group> listg = GroupManager.getInstance().getListGroupFromPemission(type);
			
			String str = StringUtill.GetSqlInGroup(listg);
			
			HashMap<Integer,User> users = new HashMap<Integer,User>();
			Connection conn = DB.getConn();
			String sql = "select * from  mduser where  usertype in " + str + "  and statues = 1 ";
	logger.info(sql);		
			Statement stmt = DB.getStatement(conn);
			ResultSet rs = DB.getResultSet(stmt, sql);
			try {
				while (rs.next()) {
					User u= UserManager.getUserFromRs(rs);
					
				}
			} catch (SQLException e) {
				e.printStackTrace();
			} finally {
				DB.close(rs);
				DB.close(stmt);
				DB.close(conn);
			}
			return users;
	   }
	   
	   public static HashMap<String,List<String>> getMapPid(){
		    
		   HashMap<String,List<String>> users = new HashMap<String,List<String>>();
			Connection conn = DB.getConn(); 
			String sql = "select * from  mduser  where statues = 1 ";
//	logger.info(sql);		
			Statement stmt = DB.getStatement(conn);
			ResultSet rs = DB.getResultSet(stmt, sql);
			try {
				while (rs.next()) {
					User u= UserManager.getUserFromRs(rs);
					List<String> list = users.get(u.getUsertype()+"");
					if(list == null ){
						list = new ArrayList<String>();
						users.put(u.getUsertype()+"", list);
					} 
					list.add(u.getUsername());
				}
			} catch (SQLException e) {
				e.printStackTrace();
			} finally {
				DB.close(rs);
				DB.close(stmt);
				DB.close(conn);
			}
			return users;
	   }
	   
	public static User check(String username, String password)
			throws UserNotFoundException, PasswordNotCorrectException, UnsupportedEncodingException {
		User u = null;
		Connection conn = DB.getConn();
logger.info(username);
		 
		String sql = "select * from mduser where username = '" + username + "' and statues = 1;";
		System.out.print(sql); 
		Statement stmt = DB.getStatement(conn); 
		ResultSet rs = DB.getResultSet(stmt, sql);
		try {
			if(!rs.next()) {
				throw new UserNotFoundException("用户不存在:" + username);
			} else {
				if(!password.equals(rs.getString("userpassword"))) {
					throw new PasswordNotCorrectException("密码不正确哦!");
				}
				u = UserManager.getUserFromRs(rs);
			}
			 
		} catch (SQLException e) {
			e.printStackTrace();
		} finally {
			DB.close(rs);
			DB.close(stmt);
			DB.close(conn);
		}
		return u;
	}
	//  激活和关闭职工
	public  static boolean setStatues(int id , int statues){
		boolean flag = false ;
		String sql = "update mduser set statues = "+statues + "  where id = " + id;
		Connection conn = DB.getConn();
		Statement stmt = DB.getStatement(conn);
		try {
			flag = stmt.execute(sql);
		} catch (SQLException e) {
			e.printStackTrace();
		}
		
		
		
		return flag ;
		
		
	}
	private static User getUserFromRs(ResultSet rs){
		User u = new User();
		try {
			u.setId(rs.getInt("id"));
			u.setUsername(rs.getString("username"));
			u.setNickusername((rs.getString("nickusername")));
			u.setUserpassword(rs.getString("userpassword"));
			u.setUsertype((rs.getInt("Usertype")));
			u.setProducts(rs.getString("products"));
			u.setEntryTime(rs.getString("entryTime"));
			u.setBranch(rs.getString("branch"));
			u.setPositions(rs.getString("Positions"));
			u.setPhone(rs.getString("phone"));
			u.setStatues(rs.getInt("statues"));
			u.setCharge(rs.getString("charge"));
			u.setChargeid(rs.getInt("chargeid"));  
			u.setLocation(rs.getString("location"));
		} catch (SQLException e) {
			e.printStackTrace();
		}	
		return u ; 
	}
}
