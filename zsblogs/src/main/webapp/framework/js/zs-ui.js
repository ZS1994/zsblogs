/**
* 2017-12-2，张顺，自己写的ui组件，依赖jquery.js、zs-ui.css
 */
//zs-validatebox-select,下拉框表单验证框，对easy-ui验证框的补充
$(function(){
	var a=$(".zs-validatebox-select");
	a.change(function(){
		if($(this).val()){
			$(this).removeClass("zs-validatebox-error");
		}else{
			$(this).addClass("zs-validatebox-error");
		}
	});
});
function validate_zs(ff){
	var a=ff.find("select.zs-validatebox-select");
	if(a && a.val()){
		a.removeClass("zs-validatebox-error");
		return true;
	}else{
		a.addClass("zs-validatebox-error");
		a.focus();
		return false;
	}
}