$(document).ready(function(){
    startclock();
    var timerID = null;  
    var timerRunning = false; 
    function showtime() {  
        Today = new Date();
        var year = Today.getFullYear();
        var NowHour = Today.getHours();  
        var NowMinute = Today.getMinutes();  
        var NowMonth = Today.getMonth();  
        var NowDate = Today.getDate();  
        var NowYear = Today.getYear();  
        var NowSecond = Today.getSeconds();  
        if (NowYear <2000)  
        NowYear=1900+NowYear;  
        Today = null;  
        Hourleft = 23 - NowHour  
        Minuteleft = 59 - NowMinute  
        Secondleft = 59 - NowSecond  
        Yearleft = year - NowYear  
        Monthleft = 3 - NowMonth
        Dateleft = 28 - NowDate
        Hourleft = Hourleft + 24 * (Dateleft)
        if (Secondleft<0)  
        {  
            Secondleft=60+Secondleft;  
            Minuteleft=Minuteleft-1;  
        } 
        if (Minuteleft<0)  
        {   
            Minuteleft=60+Minuteleft;  
            Hourleft=Hourleft-1;  
        }  
        if (Hourleft<0)  
        {  
            Hourleft=24+Hourleft;  
            Dateleft=Dateleft-1;  
        } 
        document.getElementById("hours").innerHTML=Hourleft;
        document.getElementById("mins").innerHTML=Minuteleft;
        document.getElementById("secs").innerHTML=Secondleft;
        timerRunning = true;  
    }
    setInterval(showtime,1000) 
    var timerID = null;  
    var timerRunning = false;  
    function stopclock () {  
        if(timerRunning)  
        clearTimeout(timerID);  
        timerRunning = false;  
    }  
    function startclock () {  
        stopclock();  
        showtime();  
    }  
});