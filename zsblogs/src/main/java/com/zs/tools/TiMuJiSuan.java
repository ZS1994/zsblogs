package com.zs.tools;

import com.google.gson.Gson;

public class TiMuJiSuan {

	private int arr[]={2,1,1,1,1,1,1,1,1,1};
	private Gson gson=new Gson();
	
	public void init() {
		//1
		
		//2
		if (arr[4]==3) {
			arr[1]=1;
		}else if(arr[4]==4){
			arr[1]=2;
		}else if(arr[4]==1){
			arr[1]=3;
		}else if(arr[4]==2){
			arr[1]=4;
		}
		//3
		if (arr[2]!=arr[5] && arr[2]!=arr[1] && arr[2]!=arr[3]) {
			arr[2]=1;
		}else if(arr[5]!=arr[2] && arr[5]!=arr[1] && arr[5]!=arr[3]) {
			arr[2]=2;
		}else if(arr[1]!=arr[2] && arr[1]!=arr[5] && arr[1]!=arr[3]) {
			arr[2]=3;
		}else if(arr[3]!=arr[2] && arr[3]!=arr[5] && arr[3]!=arr[1]) {
			arr[2]=4;
		}
		//4
		if (arr[0]==arr[4]) {
			arr[3]=1;
		}else if(arr[1]==arr[6]) {
			arr[3]=2;
		}else if(arr[0]==arr[8]) {
			arr[3]=3;
		}else if(arr[5]==arr[9]) {
			arr[3]=4;
		}
		//5
		if (arr[5]==arr[7]) {
			arr[5]=1;
		}else if(arr[5]==arr[3]) {
			arr[5]=2;
		}else if(arr[5]==arr[8]) {
			arr[5]=3;
		}else if(arr[5]==arr[6]) {
			arr[5]=4;
		}
		//6
		if (arr[1]==arr[7] && arr[3]==arr[7]) {
			arr[5]=1;
		}else if (arr[0]==arr[7] && arr[5]==arr[7]) {
			arr[5]=2;
		}else if (arr[2]==arr[7] && arr[9]==arr[7]) {
			arr[5]=3;
		}else if (arr[4]==arr[7] && arr[8]==arr[7]) {
			arr[5]=4;
		}
		//7
		int a=0,b=0,c=0,d=0;
		for (int i = 0; i < arr.length; i++) {
			if (arr[i]==1) {
				a++;
			}else if (arr[i]==2) {
				b++;
			}else if (arr[i]==3) {
				c++;
			}else if (arr[i]==4) {
				d++;
			}
		}
		if (a<b && a<c && a<d) {
			arr[6]=3;
		}else if (b<c && b<a && b<d) {
			arr[6]=2;
		}else if (c<a && c<b && c<d) {
			arr[6]=1;
		}else if (d<a && d<b && d<c) {
			arr[6]=4;
		}
		//8
		if (Math.abs(arr[6]-arr[0])!=1) {
			arr[7]=1;
		}else if (Math.abs(arr[4]-arr[0])!=1) {
			arr[7]=2;
		}else if (Math.abs(arr[1]-arr[0])!=1) {
			arr[7]=3;
		}else if (Math.abs(arr[9]-arr[0])!=1) {
			arr[7]=4;
		}
		//9
		if ((arr[0]==arr[5])!=(arr[5]==arr[4])) {
			arr[8]=1;
		}else if ((arr[0]==arr[5])!=(arr[9]==arr[4])) {
			arr[8]=2;
		}else if ((arr[0]==arr[5])!=(arr[1]==arr[4])) {
			arr[8]=3;
		}else if ((arr[0]==arr[5])!=(arr[8]==arr[4])) {
			arr[8]=4;
		}
		//10
		a=0;b=0;c=0;d=0;
		for (int i = 0; i < arr.length; i++) {
			if (arr[i]==1) {
				a++;
			}else if (arr[i]==2) {
				b++;
			}else if (arr[i]==3) {
				c++;
			}else if (arr[i]==4) {
				d++;
			}
		}
		int min=0,max=0;
		if (a<b && a<c && a<d) {
			min=1;
		}else if (b<c && b<a && b<d) {
			min=2;
		}else if (c<a && c<b && c<d) {
			min=3;
		}else if (d<a && d<b && d<c) {
			min=4;
		}
		if (a>b && a>c && a>d) {
			max=1;
		}else if (b>c && b>a && b>d) {
			max=2;
		}else if (c>a && c>b && c>d) {
			max=3;
		}else if (d>a && d>b && d>c) {
			max=4;
		}
		int cha=Math.abs(max-min);
		if (cha==3) {
			arr[9]=1;
		}else if (cha==2) {
			arr[9]=2;
		}else if (cha==4) {
			arr[9]=3;
		}else if (cha==1) {
			arr[9]=4;
		}

		System.out.println(gson.toJson(arr));
	}
	
	public static void main(String[] args) {
		TiMuJiSuan ti=new TiMuJiSuan();
		for (int i = 0; i < 100; i++) {
			ti.init();
		}
	}
	
}
