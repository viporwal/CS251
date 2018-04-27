BEGIN {
    flag=0
    USER=0
    PID=0
    LWP=0
    SZ=0
    TIME=0
    users=0
}

{
    if(flag == 0) {
        flag=1

        if($1 == "USER")
            USER=1
        else if($2 == "USER")
            USER=2
        else if($3 == "USER")
            USER=3
        else if($4 == "USER")
            USER=4
        else if($5 == "USER")
            USER=5
        else if($6 == "USER")
            USER=6
        else if($7 == "USER")
            USER=7
        else if($8 == "USER")
            USER=8
        else if($9 == "USER")
            USER=9

        if($1 == "PID")
            PID=1
        else if($2 == "PID")
            PID=2
        else if($3 == "PID")
            PID=3
        else if($4 == "PID")
            PID=4
        else if($5 == "PID")
            PID=5
        else if($5 == "PID")
            PID=5
        else if($6 == "PID")
            PID=6
        else if($7 == "PID")
            PID=7
        else if($8 == "PID")
            PID=8
        else if($9 == "PID")
            PID=9

        if($1 == "LWP")
            LWP=1
        else if($2 == "LWP")
            LWP=2
        else if($3 == "LWP")
            LWP=3
        else if($4 == "LWP")
            LWP=4
        else if($5 == "LWP")
            LWP=5
        else if($5 == "LWP")
            LWP=5
        else if($6 == "LWP")
            LWP=6
        else if($7 == "LWP")
            LWP=7
        else if($8 == "LWP")
            LWP=8
        else if($9 == "LWP")
            LWP=9

        if($1 == "SZ")
            SZ=1
        else if($2 == "SZ")
            SZ=2
        else if($3 == "SZ")
            SZ=3
        else if($4 == "SZ")
            SZ=4
        else if($5 == "SZ")
            SZ=5
        else if($5 == "SZ")
            SZ=5
        else if($6 == "SZ")
            SZ=6
        else if($7 == "SZ")
            SZ=7
        else if($8 == "SZ")
            SZ=8
        else if($9 == "SZ")
            SZ=9
        
        if($1 == "TIME")
            TIME=1
        else if($2 == "TIME")
            TIME=2
        else if($3 == "TIME")
            TIME=3
        else if($4 == "TIME")
            TIME=4
        else if($5 == "TIME")
            TIME=5
        else if($5 == "TIME")
            TIME=5
        else if($6 == "TIME")
            TIME=6
        else if($7 == "TIME")
            TIME=7
        else if($8 == "TIME")
            TIME=8
        else if($9 == "TIME")
            TIME=9

    }
    else {
        if(user[$USER] == "") {
            user[$USER] = $USER
            split($TIME, tt, ":")
            time[$USER] = (tt[1]*3600 + tt[2]*60 + tt[3]) 
            thread[$USER] = 1
            pid[$PID] = $USER
            memory[$USER] = $SZ
        }
        else {
            thread[$USER]++
            split($TIME, t, ":")
            cal = (t[1]*3600 + t[2]*60 + t[3])
            time[$USER] += cal
            if ( pid[$PID] == "") {
                memory[$USER] += $SZ
                pid[$PID] = $USER
            }
        }       
    }


}


END {
    for(i in user) {
        users++
        process[i] = 0
    }
    for(i in pid) {
        process[pid[i]]++
    }

    print "Total Users: "users
    for(i in user) {
        print i
        print "Processes: "process[i] ", Threads: "thread[i] ", CPU time(sec): "time[i] ", Memory: "memory[i]
    }
}
