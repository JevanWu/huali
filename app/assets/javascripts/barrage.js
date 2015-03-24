var tabContainer;
// 遍历执行元素的移动
function Marquee() {
    for (var i = 0; i < msgStrings.length; i++) {
        var cellMsg = document.getElementById("msg" + i);
        var rightPadd = cellMsg.style.right;
        var rightValue = rightPadd.substring(0, rightPadd.length - 2);
        if (rightValue <= tabContainer.offsetWidth) {
            rightValue = cellSpeed[i] + parseInt(rightValue);
            cellMsg.style.right = rightValue + "px";
        }
        else {
            cellMsg.style.right = "0px";
        }
    }
}
// 模拟的字符串
var msgStrings = ["后来。。。", "挪威的森林", "Fly go  a beauty", "My dream is a small rice", "today goto next day", "you cannot seee me "];
var cellSpeed = new Array();
function InitAnimal() {
    for (var i = 0; i < msgStrings.length; i++) {
        // 创建文字的容器层
        var msgCell = document.createElement("div");
        msgCell.id = "msg" + i;
        msgCell.className = "MsgTip";
        // 随机高度
        var topCell = Math.floor(Math.random() * tabContainer.offsetHeight);
        msgCell.style.top = topCell + "px";
        msgCell.style.right = "0px";
        msgCell.style.position = "absolute";
        msgCell.innerHTML = msgStrings[i];
        // 加入元素
        tabContainer.appendChild(msgCell);
        // 随机速度
        var speendCell = Math.floor(Math.random() * 8) + 1;
        cellSpeed.push(speendCell);
    }
}
// 初始化
window.onload = function () {
    tabContainer = document.getElementById("demo");
    InitAnimal();
    var MyMar = setInterval(Marquee, 30);
};