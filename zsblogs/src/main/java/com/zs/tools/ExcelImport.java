package com.zs.tools;

import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.InputStream;
import java.text.DecimalFormat;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;

import org.apache.commons.lang3.StringUtils;
import org.apache.log4j.Logger;
import org.apache.poi.hssf.usermodel.HSSFCell;
import org.apache.poi.hssf.usermodel.HSSFDataFormat;
import org.apache.poi.hssf.usermodel.HSSFDateUtil;
import org.apache.poi.hssf.usermodel.HSSFWorkbook;
import org.apache.poi.ss.usermodel.Cell;
import org.apache.poi.ss.usermodel.CellStyle;
import org.apache.poi.ss.usermodel.Row;
import org.apache.poi.ss.usermodel.Sheet;
import org.apache.poi.ss.usermodel.Workbook;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;



public class ExcelImport {
	
	static Logger log=Logger.getLogger(ExcelImport.class);
	
	/**
	 * 黄光辉    数据导入
	 * <br>从excle表格中获取数据
	 * @param filePath
	 * @throws IOException
	 * @Return object二维数组
	 */
	public static List<String[]> getDataFromExcel(String fileName,File file) throws IOException{
		List<String[]> list=new ArrayList<String[]>();
		//判断是否为excel类型文件
		if(!fileName.endsWith(".xls")&&!fileName.endsWith(".xlsx")){
			log.error("文件不是excel类型:"+fileName);
		}else {
			FileInputStream fis =null;
			Workbook wookbook = null;
			//获取一个绝对地址的流
			fis = new FileInputStream(file);
			if (fileName.endsWith(".xls")) {
				//2003版本的excel，用.xls结尾
				wookbook = new HSSFWorkbook(fis);//得到工作簿
			}else if (fileName.endsWith(".xlsx")) {
				//2007版本的excel，用.xlsx结尾
				wookbook = new XSSFWorkbook(fis);//得到工作簿    
			}
			//得到一个工作表
			Sheet sheet = wookbook.getSheetAt(0);
			//获得表头
			Row rowHead = sheet.getRow(0);
			//获取列数
			int cols=rowHead.getPhysicalNumberOfCells();
			//获得数据的总行数
			int totalRowNum = sheet.getLastRowNum();
			//获得所有数据
			for(int i = 0 ; i <=totalRowNum ; i++){
				//获得第i行对象
				Row row = sheet.getRow(i);
				if (row==null) {
					continue;
				}
				//获得获得第i行第j列的 String类型对象
				String ss[]=new String[cols];
				boolean isNull=true;
				for (int j = 0; j <cols; j++) {
					Cell cell = row.getCell(j);
					String str=parseExcel(cell);
					ss[j]=str.trim();
					if (str==null || str.trim().equals("")) {
					}else {
						isNull=false;
					}
				}
				if (isNull==false) {
					list.add(ss);
				}
			}
		}
		return list;
	}
	
	public static List<String[]> getDataFromExcel2(String fileName,InputStream fis) throws IOException{
		List<String[]> list=new ArrayList<String[]>();
		//判断是否为excel类型文件
		if(!fileName.endsWith(".xls")&&!fileName.endsWith(".xlsx")){
			log.error("文件不是excel类型:"+fileName);
		}else {
			Workbook wookbook = null;
			if (fileName.endsWith(".xls")) {
				//2003版本的excel，用.xls结尾
				wookbook = new HSSFWorkbook(fis);//得到工作簿
			}else if (fileName.endsWith(".xlsx")) {
				//2007版本的excel，用.xlsx结尾
				wookbook = new XSSFWorkbook(fis);//得到工作簿    
			}
			//得到一个工作表
			Sheet sheet = wookbook.getSheetAt(0);
			//获得表头
			Row rowHead = sheet.getRow(0);
			//获取列数
			int cols=rowHead.getPhysicalNumberOfCells();
			//获得数据的总行数
			int totalRowNum = sheet.getLastRowNum();
			//获得所有数据
			for(int i = 0 ; i <=totalRowNum ; i++){
				//获得第i行对象
				Row row = sheet.getRow(i);
				if (row==null) {
					continue;
				}
				//获得获得第i行第j列的 String类型对象
				String ss[]=new String[cols];
				boolean isNull=true;
				for (int j = 0; j <cols; j++) {
					Cell cell = row.getCell(j);
					String str=parseExcel2(cell);
					ss[j]=str.trim();
					if (str==null || str.trim().equals("")) {
					}else {
						isNull=false;
					}
				}
				if (isNull==false) {
					list.add(ss);
				}
			}
		}
		return list;
	}
	
	/**
	 * 单元格格式自动处理
	 * 2017-4-25，张顺，完善类型处理
	 * @param cell 单元格
	 * @return
	 */
	private static String parseExcel(Cell cell) {
		String result = new String();
		if (cell==null) {
			result="";
		}else {
			switch (cell.getCellType()) {
			case HSSFCell.CELL_TYPE_NUMERIC:// 数字类型
				if (HSSFDateUtil.isCellDateFormatted(cell)) {// 处理日期格式、时间格式
					SimpleDateFormat sdf = null;
					if (cell.getCellStyle().getDataFormat() == HSSFDataFormat.getBuiltinFormat("yyyy-MM-dd")) {
						sdf = new SimpleDateFormat("yyyy-MM-dd");
					} else {// 日期
						sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
					}
					Date date = cell.getDateCellValue();
					result = sdf.format(date);
				} else if (cell.getCellStyle().getDataFormat() == 58) {
					// 处理自定义日期格式：m月d日(通过判断单元格的格式id解决，id的值是58)
					SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
					double value = cell.getNumericCellValue();
					Date date = org.apache.poi.ss.usermodel.DateUtil
					.getJavaDate(value);
					result = sdf.format(date);
				} else {
					/*
					double value = cell.getNumericCellValue();
					CellStyle style = cell.getCellStyle();
					DecimalFormat format = new DecimalFormat();
					String temp = style.getDataFormatString();
					// 单元格设置成常规
					if (temp.equals("General")) {
						format.applyPattern("#");
					}
					result = format.format(value);
					*/
					cell.setCellType(Cell.CELL_TYPE_STRING);
					result=cell.getStringCellValue();
				}
				break;
//			case HSSFCell.CELL_TYPE_STRING:// String类型
//				result = cell.getStringCellValue();
//				break;
//			case HSSFCell.CELL_TYPE_BLANK:
//				result = "";
//				break;
//			case HSSFCell.CELL_TYPE_FORMULA://公式类型
//				result = cell.getNumericCellValue()+"";
//				break;
			default:
				cell.setCellType(Cell.CELL_TYPE_STRING);
				result=cell.getStringCellValue();
				break;
			}
		}
		return result;
	}
	
	/**
	 * 单元格格式自动处理
	 * 2017-8-23，张顺，新版的各类型处理
	 * @param cell 单元格
	 * @return
	 */
	private static String parseExcel2(Cell cell) {
		String temp = "";
		if (cell==null) {
			temp="";
		}else {
			switch (cell.getCellType()) {  
            case Cell.CELL_TYPE_STRING:  
                temp = cell.getStringCellValue().trim();  
                break;  
            case Cell.CELL_TYPE_BOOLEAN:  
                temp = String.valueOf(cell.getBooleanCellValue());  
                break;  
            case Cell.CELL_TYPE_FORMULA:  
                temp = String.valueOf(cell.getNumericCellValue());  
                break;  
            case Cell.CELL_TYPE_NUMERIC:
                if (HSSFDateUtil.isCellDateFormatted(cell)) {  
                	SimpleDateFormat sdf = null;
					if (cell.getCellStyle().getDataFormat() == HSSFDataFormat.getBuiltinFormat("yyyy-MM-dd")) {
						sdf = new SimpleDateFormat("yyyy-MM-dd");
					} else {// 日期
						sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
					}
					Date date = cell.getDateCellValue();
					temp = sdf.format(date); 
                }else if (cell.getCellStyle().getDataFormat() == 58) {
					// 处理自定义日期格式：m月d日(通过判断单元格的格式id解决，id的值是58)
					SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
					double value = cell.getNumericCellValue();
					Date date = org.apache.poi.ss.usermodel.DateUtil.getJavaDate(value);
					temp = sdf.format(date);
				}else {  
                    temp = new DecimalFormat("#.######").format(cell.getNumericCellValue());  
                }  
                break;  
            case Cell.CELL_TYPE_BLANK:  
                temp = "";  
                break;  
            case Cell.CELL_TYPE_ERROR:  
                temp = "";  
                break;  
            default:  
                temp = cell.toString().trim();  
                break;  
            }  
		}
		return temp;
	}

}
