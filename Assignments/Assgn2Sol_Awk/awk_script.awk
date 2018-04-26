#!/usr/bin/gawk
BEGIN {
cflag=0;
no_com=0;
sflag=0;
no_str=0;
got1c=0;
}

{

if(cflag == 1 ){
	no_com=no_com+1;
	got1c=1;
}
else {got1c=0}

sflag=0;

for (i=1;i<=NF;i++){
	
	if($i ~ /\/\*/){
		if(sflag==0 && cflag==0){
			if(got1c==0){
				no_com=no_com+1;
			}
			got1c=1;
			cflag=1;
			continue;
		}
	}

	if($i ~ /\*\//){
		if(sflag==0 && cflag==1){
			cflag=0;
			continue;
		}
	}

	if($i ~ /"/){
		if (sflag==0 && cflag==0){
			no_str=no_str+1;
			sflag=1;
			continue;
		}
	
		if (sflag==1 && cflag==0){
			sflag=0;
			continue;
		}
	}
	
	if($i ~ /\/\//){
		if(sflag==0 && cflag==0){
			if(got1c==0){
				no_com=no_com+1;
			}
			else {got1c=0;}
			cflag=0;
			break;
		}
	}
}

}

END{
print no_com;
print no_str;
}
