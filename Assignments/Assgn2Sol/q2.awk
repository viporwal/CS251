BEGIN {
OFMT = "%.0f"
}
function timez(initia, fina)
{
	split(initia,ini,":");
	split(fina,fin,":");	
	return (fin[1]-ini[1])*3600+(fin[2]-ini[2])*60+(fin[3]-ini[3])             
  
}
{
	split($9,vals,":");	
	if ($3": "$5 in packets)
		{
		final[$3": "$5]=$1;
		}
	else
		{
		final[$3": "$5]=$1;
		initial[$3": "$5]=$1;
		data[$3": "$5]=0;
		bytes[$3": "$5]=0;
		retrans[$3": "$5]=0;
		}
	packets[$3": "$5]++;	
	
	if($NF!=0)
	{
		if ($3" "$5" "vals[1]"f" in appeared)
			{
			retrans[$3": "$5]+=$NF
			
			}
		else if ($3" "$5" "vals[2]"l" in appeared)
			{
			retrans[$3": "$5]+=$NF	
			}
		else	{
			appeared[$3" "$5" "vals[1]"f"]=1
			appeared[$3" "$5" "vals[2]"l"]=1
			
			}

		data[$3": "$5]++;
		bytes[$3": "$5]+=$NF
		
	}	
	
}
END {
for(i in packets)
	{
	split(i,vag," ")
	if (i in printed)
		{
		}
	else
	{	printed[i]=1
		printed[vag[2]" "vag[1]]=1
		j=vag[2]" "vag[1]		
		
		print "Connection (A="vag[2]", B="vag[1]" )" 
		print --bignum "A-->B  #packets="packets[j]" #datapackets="data[j]" #bytes="bytes[j]" #retrans="retrans[j]"  #xput="(bytes[j]-retrans[j])/timez(initial[j],final[j])
		print --bignum "B-->A  #packets="packets[i]" #datapackets="data[i]" #bytes="bytes[i]" #retrans="retrans[i]"  #xput="(bytes[i]-retrans[i])/timez(initial[i],final[i])
		print "-----------------------------------------------------------------------------"
			
	}
	}
}
