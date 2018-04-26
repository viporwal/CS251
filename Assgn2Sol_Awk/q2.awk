#!/usr/bin/gawk
function diff(init, fina)
{
	split(init,ini,":");
	split(fina,fin,":");	
	return (fin[1]-ini[1])*3600+(fin[2]-ini[2])*60+(fin[3]-ini[3])             
  
}
BEGIN{

}

{
   	if ($NF > 0){
		retra[$3","$5]+=0;
                if( ($3","$5) in start){
			final[$3","$5] = $1
		}
		else{
			start[$3","$5] = $1
		}
		split($9,seq,/[:,]/);
		low=seq[1]
		high=seq[2]
		split($5,ipa,":");
		ipB=ipa[1]
		if(high-low==1448)
			retrans[$3,ipB,high,low]+=1448
		if(high-low==2896){
			retrans[$3,ipB,(high+low)/2,low]+=1448
			retrans[$3,ipB,high,(high+low)/2]+=1448
		}
		if(high-low==4344){
			retrans[$3,ipB,(high+2*low)/3,low]+=1448
			retrans[$3,ipB,(2*high+low)/3,(high+2*low)/3]+=1448
			retrans[$3,ipB,high,(2*high+low)/3]+=1448
		}
		
		packet[$3","$5]++;
		datapacket[$3","$5]++;
		data[$3","$5]+=$NF;
        }

        else{
		retra[$3","$5]+=0;
              	if( ($3","$5) in start){
			final[$3","$5] = $1
		}
		else{
			start[$3","$5] = $1
		}
		
		packet[$3","$5]++;
		data[$3","$5]+=$NF;
		datapacket[$3","$5]+=0;
        }

}
END{
	for(j in retrans){
                split(j, sep, SUBSEP);
                sendip=sep[1]
                recip=sep[2]
                retra[sendip","recip":"]+=retrans[j]-1448
        }
	for( i in final){
		printed[i]=0;
	}
       	for( i in final){

		if(printed[i] == 1){continue;}		
		split(i, arr, /[:,]/)
		printf "Connection "; printf "(A="; printf arr[1];
		printf  " B="; printf arr[2]; printf ")";
		printf "\n";
		printf "\n";
			
		printed[i]=1;
		
		printf "A-->B " "#packets=";
		printf packet[i];
		printf ", #datapackets=";
		printf datapacket[i]; 
		printf ", #bytes=";
	        printf data[i];
		printf ", #retrans=";
		printf retra[i];
		printf ", #xput="; 
		printf ("%d",(data[i]-retra[i])/(diff(start[i],final[i])));
	        printf " bytes/sec";
		printf "\n";
		printf "\n";
		printf "B-->A " "#packets="; 
		printf packet[arr[2]","arr[1]":"];
		printf ", #datapackets=";
		printf datapacket[arr[2]","arr[1]":"];
		printf ", #bytes=";
		printf data[arr[2]","arr[1]":"];
		printf ", #retrans=";
		printf retra[arr[2]","arr[1]":"]; 
		printf ", #xput="; 
		printf ("%d",(data[arr[2]","arr[1]":"]-retra[arr[2]","arr[1]":"])/(diff(start[arr[2]","arr[1]":"],final[arr[2]","arr[1]":"])));
		print " bytes/sec";		
		printf "\n";
		printed[arr[2]","arr[1]":"]=1;		
       }
}

