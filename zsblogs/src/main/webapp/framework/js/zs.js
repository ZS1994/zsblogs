/**
 * 2017-2-21，张顺，这里写一些公共的方法，每个页面都会引用这个js
 */
function getNowTime(fgf){
	var date=new Date();
	var getYear=date.getFullYear();
	var getMonth=date.getMonth()+1;
	if(getMonth<10){
		getMonth="0"+getMonth;
	}
	var getDate=date.getDate();
	var getHours=date.getHours();
	var getMinutes=date.getMinutes();
	var getSeconds=date.getSeconds();
	var times=getYear+fgf+getMonth+fgf+getDate+" "+getHours+":"+getMinutes+":"+getSeconds;
	return times;
}
function getNowDate(fgf){
	var date=new Date();
	var getYear=date.getFullYear();
	var getMonth=date.getMonth()+1;
	if(getMonth<10){
		getMonth="0"+getMonth;
	}
	var getDate=date.getDate();
	var times=getYear+fgf+getMonth+fgf+getDate;
	return times;
}
function displayTime(){
	$("#nowTime").html(getNowTime("-"));
	setTimeout("displayTime()",1000);
}

/*张顺，2017-3-3，查询栏位的查询函数，这里需要注意几个id不能改变：1、查询栏位表单id固定为search。2、表格id固定为dg。*/
function formToJson(formObj){
   var o={};
   var a=formObj.serializeArray();
   $.each(a, function() {
       if(this.value){
           if (o[this.name]) {
               if (!o[this.name].push) {
                   o[this.name]=[ o[this.name] ];
               }
                   o[this.name].push(this.value || null);
           }else {
               if($("[name="+this.name+"]:checkbox",formObj).length){
                   o[this.name]=[this.value];
               }else{
                   o[this.name]=this.value || null;
               }
           }
       }
   });
   return o;
}

/*张顺，2017-3-11，自定义easyUI的验证框*/
$.extend($.fn.validatebox.defaults.rules, {
    number: {
		validator: function(value,param){
			return !isNaN(value);
		},
		message: '必须为数字.'
    },
    contains: {
		validator: function(value,param){
			return value.indexOf(param[0])>=0;
		},
		message: '必须包含{0}'
    }
});
/*判断是否是json对象或者json数组*/
function isJson(obj){
	/*
	console.log(typeof(obj));
	console.log(Object.prototype.toString.call(obj).toLowerCase());
	console.log((Object.prototype.toString.call(obj).toLowerCase() == "[object object]" || Object.prototype.toString.call(obj).toLowerCase() == "[object array]"));
	*/
	var isj = typeof(obj) == "object" && (Object.prototype.toString.call(obj).toLowerCase() == "[object object]" || Object.prototype.toString.call(obj).toLowerCase() == "[object array]"); 
	return isj;
}
/*毫秒数转成时间字符串的形式*/
function getDateByMs(date,fgf){
	var getYear=date.getFullYear();
	var getMonth=date.getMonth()+1;
	if(getMonth<10){
		getMonth="0"+getMonth;
	}
	var getDate=date.getDate();
	if(getDate<10){
		getDate="0"+getDate;
	}
	var times=getYear+fgf+getMonth+fgf+getDate;
	return times;
}
/*张顺，2017-5-9，解决easyui的datagrid万条以上时序号显示不全的问题*/
$.extend($.fn.datagrid.methods, {    
    fixRownumber : function (jq) {    
        return jq.each(function () {    
            var panel = $(this).datagrid("getPanel");    
            var clone = $(".datagrid-cell-rownumber", panel).last().clone();    
            clone.css({    
                "position" : "absolute",    
                left : -1000    
            }).appendTo("body");    
            var width = clone.width("auto").width();    
            if (width > 25) {    
                //多加5个像素,保持一点边距    
                $(".datagrid-header-rownumber,.datagrid-cell-rownumber", panel).width(width + 5);    
                $(this).datagrid("resize");    
                //一些清理工作    
                clone.remove();    
                clone = null;    
            } else {    
                //还原成默认状态    
                $(".datagrid-header-rownumber,.datagrid-cell-rownumber", panel).removeAttr("style");    
            }    
        });    
    }    
});
/*张顺，2017-6-24，为了实现单击单元格进入编辑状态，点击保存进行保存的效果*/
$.extend($.fn.datagrid.methods, {
	editCell: function(jq,param){
		return jq.each(function(){
			var opts = $(this).datagrid('options');
			var fields = $(this).datagrid('getColumnFields',true).concat($(this).datagrid('getColumnFields'));
			for(var i=0; i<fields.length; i++){
				var col = $(this).datagrid('getColumnOption', fields[i]);
				col.editor1 = col.editor;
				if (fields[i] != param.field){
					col.editor = null;
				}
			}
			$(this).datagrid('beginEdit', param.index);
			for(var i=0; i<fields.length; i++){
				var col = $(this).datagrid('getColumnOption', fields[i]);
				col.editor = col.editor1;
			}
		});
	}
});
var editIndex = undefined;
function endEditing(){
	if (editIndex == undefined){return true}
	if ($('#dg').datagrid('validateRow', editIndex)){
		$('#dg').datagrid('endEdit', editIndex);
		editIndex = undefined;
		return true;
	} else {
		return false;
	}
}
function onClickCell(index, field){
	if (endEditing()){
		$('#dg').datagrid('selectRow', index)
				.datagrid('editCell', {index:index,field:field});
		editIndex = index;
	}
}
//张顺，2017-6-26，json转url参数,只转第一层的属性，子对象不会被转
function jsonObjTransToUrlparam(param){
	var str="";
	for(var p in param){
		if(param[p]!=null && isJson(param[p])==false){
			str=str+"&"+p+"="+param[p];
		}
	}
	return str.substr(1);
}
