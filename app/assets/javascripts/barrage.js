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

function getArrayItems(arr, num) {
    //新建一个数组,将传入的数组复制过来,用于运算,而不要直接操作传入的数组;
    var temp_array = new Array();
    for (var index in arr) {
        temp_array.push(arr[index]);
    }
    //取出的数值项,保存在此数组
    var return_array = new Array();
    for (var i = 0; i<num; i++) {
        //判断如果数组还有可以取出的元素,以防下标越界
        if (temp_array.length>0) {
            //在数组中产生一个随机索引
            var arrIndex = Math.floor(Math.random()*temp_array.length);
            //将此随机索引的对应的数组元素值复制出来
            return_array[i] = temp_array[arrIndex];
            //然后删掉此索引的数组元素,这时候temp_array变为新的数组
            temp_array.splice(arrIndex, 1);
        } else {
            //数组中数据项取完后,退出循环,比如数组本来只有10项,但要求取出20项.
            break;
        }
    }
    return return_array;
}
// 模拟的字符串
var msgStrings = ["宝贝收到了，太给力了，非常喜欢，很漂亮卖家太细心了，包装很精美。满分", "不错，很好大上的感觉，太喜欢了，大爱。颜色也好看", "花很漂亮，女朋友很喜欢，店家很给力，下次需要还会来", "第一次买永生花，老婆收到很惊喜，又喜欢！很漂亮，不错！", "很漂亮的花，女朋友很喜欢，有需要还会来", "包装的很完美，卖家发货速度真是快的呀，与描述的一模一样。","宝贝收到了，包装很不错，买来送人正好，有需要还会再来的","宝贝很不错，包装很精致，颜色很正，花型一点都没有损坏，很漂亮，很满意。","第一次购买，送人的，很喜欢，比鲜花要好，好保存，好评","宝贝收到了，包装精美，花很漂亮，满意的网购。","闺蜜的生日会上送给她的，惊喜一下，很喜欢，颜色很漂亮很鲜艳，包装很上档次，送人很有面，好评","宝贝收到了。花很漂亮，老婆很喜欢。浪漫的节奏。","喜欢这个创意，东西很漂亮","朋友挺喜欢的，中途快递还发生了点小意外店主还帮忙处理了，太感谢了","送姐们儿的生日礼物～她收到很惊喜，说香香的～还有生日卡～赞！美翻","宝贝很棒！女朋友很喜欢！关键顺丰特别快。服务态度也好。很满意的一次网购。","还可以，就是觉得图片比实物好看","很棒，花很好看，卖家服务态度也很好。好评！","东西不错，味道淡淡的香，和实物一样，尤其是花瓣的颜色","迟到的评价 东西很好 物流很给力"];
var cellSpeed = new Array();
msgStrings = getArrayItems(msgStrings,5)
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
        var speendCell = Math.floor(Math.random() * 5) + 1;
        cellSpeed.push(i+1);
    }
}
// 初始化
window.onload = function () {
    tabContainer = document.getElementById("demo");
    InitAnimal();
    var MyMar = setInterval(Marquee, 40);
};