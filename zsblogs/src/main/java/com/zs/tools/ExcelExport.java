/**
 * 
 */
package com.zs.tools;

import java.io.FileOutputStream;

import org.apache.log4j.Logger;
import org.apache.poi.hssf.usermodel.HSSFCell;
import org.apache.poi.hssf.usermodel.HSSFCellStyle;
import org.apache.poi.hssf.usermodel.HSSFDataFormat;
import org.apache.poi.hssf.usermodel.HSSFFont;
import org.apache.poi.hssf.usermodel.HSSFRow;
import org.apache.poi.hssf.usermodel.HSSFSheet;
import org.apache.poi.hssf.usermodel.HSSFWorkbook;

/**
 * @author 黄光辉
 *<br/>这个类是用来进行数据导出	
 *
 */
public class ExcelExport {
	
	static Logger log=Logger.getLogger(ExcelExport.class);
	
	/**
	 * @author 黄光辉
	 * 数据导出不分工作表，适用于小数据量
	 * 
	 */
	public static void OutExcel(Object[] obj, Object[][] obj2 , String path,String sheetName){
		try {     
			// 创建新的Excel 工作簿     
			HSSFWorkbook workbook = new HSSFWorkbook();    
			// 在Excel 工作簿中建一工作表    
			HSSFSheet sheet = workbook.createSheet(sheetName); 
			// 设置单元格格式(文本) 
			HSSFCellStyle cellStyle = workbook.createCellStyle(); 
			// 生成一个字体   
	        HSSFFont font = workbook.createFont();
	        font.setFontName("宋体");
	        font.setFontHeightInPoints((short) 12); //设置字号
	        font.setBoldweight(HSSFFont.BOLDWEIGHT_NORMAL); //设置字体样式 正常显示
			cellStyle.setFont(font);
			cellStyle.setDataFormat(HSSFDataFormat.getBuiltinFormat("@"));         
			// 在索引0的位置创建行（第一行）     
			HSSFRow row = sheet.createRow((int) 0); 
			for(int i = 0 ; i < obj.length ; i++){
				HSSFCell cell1 = row.createCell((int) i);
				cell1.setCellType(HSSFCell.CELL_TYPE_STRING); 
//				cell1.setEncoding(HSSFCell.ENCODING_UTF_16);
				cell1.setCellValue(obj[i].toString());
			}
			for(int j = 0 ; j < obj2.length ; j++){    
				row = sheet.createRow((int) j+1);     
				//设置i列从第二列开始     
				for (int i = 0; i < obj2[j].length; i++) {      
					HSSFCell cell = row.createCell((int) (i));   
					// 设置单元格格式        
					cell.setCellStyle(cellStyle);  
					cell.setCellType(HSSFCell.CELL_TYPE_STRING); 
//					cell.setEncoding(HSSFCell.ENCODING_UTF_16); 
					if (obj2[j][i]==null) {
						cell.setCellValue(""); 
					}else{
						cell.setCellValue(obj2[j][i].toString());    
					}
				}            
			}        
			// 新建一输出文件流    
			FileOutputStream fOut = new FileOutputStream(path);  
			// 把相应的Excel 工作簿存盘    
			workbook.write(fOut);  
			// 操作结束，关闭文件  
			fOut.flush();   
			fOut.close();    
		}catch (Exception ioexception) { 
			ioexception.printStackTrace();
			log.error("文件导出失败");
		}  
	}
	
	
	/**
	 * @author 黄光辉
	 * 数据导出分工作表，适用于数据量比较大
	 * 
	 */
	public static void OutExcel1(Object[] obj, Object[][] obj2 , String path){
		try {     
			// 创建新的Excel 工作簿     
			HSSFWorkbook workbook = new HSSFWorkbook();    
			// 设置单元格格式(文本) 
			HSSFCellStyle cellStyle = workbook.createCellStyle(); 
			// 生成一个字体   
			HSSFFont font = workbook.createFont();
			font.setFontName("宋体");
			font.setFontHeightInPoints((short) 12); //设置字号
			font.setBoldweight(HSSFFont.BOLDWEIGHT_NORMAL); //设置字体样式 正常显示
			cellStyle.setFont(font);
			cellStyle.setDataFormat(HSSFDataFormat.getBuiltinFormat("@"));         
			int index = obj2.length/50000;
			for (int k = 0; k <= index; k++) {
				// 在Excel 工作簿中建一工作表    
				HSSFSheet sheet = workbook.createSheet(k*50000+"-"+(k+1)*50000+"条数据");
				// 在索引0的位置创建行（第一行）     
				HSSFRow row = sheet.createRow((int) 0); 
				for(int i = 0 ; i < obj.length ; i++){
					HSSFCell cell1 = row.createCell((int) i);
					cell1.setCellType(HSSFCell.CELL_TYPE_STRING); 
//				cell1.setEncoding(HSSFCell.ENCODING_UTF_16);
					cell1.setCellValue(obj[i].toString());
				}
				if(k==index){
					for(int j = k*50000 ; j < obj2.length ; j++){    
						row = sheet.createRow((int) j+1-k*50000);     
						//设置i列从第二列开始     
						for (int i = 0; i < obj2[j].length; i++) {      
							HSSFCell cell = row.createCell((int) (i));   
							// 设置单元格格式        
							cell.setCellStyle(cellStyle);  
							cell.setCellType(HSSFCell.CELL_TYPE_STRING); 
//					cell.setEncoding(HSSFCell.ENCODING_UTF_16); 
							if (obj2[j][i]==null) {
								cell.setCellValue(""); 
							}else{
								cell.setCellValue(obj2[j][i].toString());    
							}
						}            
					}        
				}else{
					for(int j = k*50000 ; j < (k+1)*50000 ; j++){    
						row = sheet.createRow((int) j+1-k*50000);     
						//设置i列从第二列开始     
						for (int i = 0; i < obj2[j].length; i++) {      
							HSSFCell cell = row.createCell((int) (i));   
							// 设置单元格格式        
							cell.setCellStyle(cellStyle);  
							cell.setCellType(HSSFCell.CELL_TYPE_STRING); 
//					cell.setEncoding(HSSFCell.ENCODING_UTF_16); 
							if (obj2[j][i]==null) {
								cell.setCellValue(""); 
							}else{
								cell.setCellValue(obj2[j][i].toString());    
							}
						}            
					} 
				}
			}
			// 新建一输出文件流    
			FileOutputStream fOut = new FileOutputStream(path);  
			// 把相应的Excel 工作簿存盘    
			workbook.write(fOut);  
			// 操作结束，关闭文件  
			fOut.flush();   
			fOut.close();    
		}catch (Exception ioexception) { 
			ioexception.printStackTrace();
			log.error("文件导出失败");
		}  
	}
	
	/**
	 * @author 黄光辉
	 * 适用于表头栏位有多行
	 * 数据导出不分工作表，适用于小数据量
	 * 
	 */
	public static void OutExcel2line(Object[][] obj1, Object[][] obj2 , String path,String sheetName){
		try {     
			// 创建新的Excel 工作簿     
			HSSFWorkbook workbook = new HSSFWorkbook();    
			// 在Excel 工作簿中建一工作表    
			HSSFSheet sheet = workbook.createSheet(sheetName); 
			// 设置单元格格式(文本) 
			HSSFCellStyle cellStyle = workbook.createCellStyle(); 
			// 生成一个字体   
	        HSSFFont font = workbook.createFont();
	        font.setFontName("宋体");
	        font.setFontHeightInPoints((short) 12); //设置字号
	        font.setBoldweight(HSSFFont.BOLDWEIGHT_NORMAL); //设置字体样式 正常显示
			cellStyle.setFont(font);
			cellStyle.setDataFormat(HSSFDataFormat.getBuiltinFormat("@"));         
			HSSFRow row =sheet.createRow((int) 0); 
			for (int i = 0; i < obj1.length; i++) {
				// 在索引0的位置创建行（第一行）     
				row = sheet.createRow((int) i); 
				for(int j = 0 ; j < obj1[i].length ; j++){
					HSSFCell cell1 = row.createCell((int) j);
					cell1.setCellType(HSSFCell.CELL_TYPE_STRING); 
//				cell1.setEncoding(HSSFCell.ENCODING_UTF_16);
					cell1.setCellValue(obj1[i][j].toString());
				}
				
			}
			for(int j = 0 ; j < obj2.length ; j++){    
				row = sheet.createRow((int) j+obj1.length);     
				//设置i列从第二列开始     
				for (int i = 0; i < obj2[j].length; i++) {      
					HSSFCell cell = row.createCell((int) (i));   
					// 设置单元格格式        
					cell.setCellStyle(cellStyle);  
					cell.setCellType(HSSFCell.CELL_TYPE_STRING); 
//					cell.setEncoding(HSSFCell.ENCODING_UTF_16); 
					if (obj2[j][i]==null) {
						cell.setCellValue(""); 
					}else{
						cell.setCellValue(obj2[j][i].toString());    
					}
				}            
			}        
			// 新建一输出文件流    
			FileOutputStream fOut = new FileOutputStream(path);  
			// 把相应的Excel 工作簿存盘    
			workbook.write(fOut);  
			// 操作结束，关闭文件  
			fOut.flush();   
			fOut.close();    
		}catch (Exception ioexception) { 
			ioexception.printStackTrace();
			log.error("文件导出失败");
		}  
	}
}
