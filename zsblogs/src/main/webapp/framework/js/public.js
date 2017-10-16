/**
 * 纯粹的公共函数，除了依赖jquery之外，不依赖任何第三方库
 */
/*判断是否是json对象或者json数组*/
function isJson(obj){
	var isj = typeof(obj) == "object" && (Object.prototype.toString.call(obj).toLowerCase() == "[object object]" || Object.prototype.toString.call(obj).toLowerCase() == "[object array]"); 
	return isj;
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
/*张顺，2017-10-16，日期格式化函数，使用方法：date.Format("yyyy年MM月dd hh:mm:ss")*/
Date.prototype.Format = function (fmt) { //author: meizz
  var o = {
    "M+": this.getMonth() + 1, //月份
    "d+": this.getDate(), //日
    "h+": this.getHours(), //小时
    "m+": this.getMinutes(), //分
    "s+": this.getSeconds(), //秒
    "q+": Math.floor((this.getMonth() + 3) / 3), //季度
    "S": this.getMilliseconds() //毫秒
  };
  if (/(y+)/.test(fmt)) fmt = fmt.replace(RegExp.$1, (this.getFullYear() + "").substr(4 - RegExp.$1.length));
  for (var k in o)
  if (new RegExp("(" + k + ")").test(fmt)) fmt = fmt.replace(RegExp.$1, (RegExp.$1.length == 1) ? (o[k]) : (("00" + o[k]).substr(("" + o[k]).length)));
  return fmt;
}
