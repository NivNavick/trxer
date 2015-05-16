/**
 * @return {number}
 */
function GetTotal() {
    var myTotal = 0;
    for (var j = 0; j < myData.length; j++) {
        myTotal += (typeof myData[j] == 'number') ? myData[j] : 0;
    }
    return myTotal;
}


function CreatePie() {
    var canvas;
    var ctx;
    var lastend = 0;
    var myTotal = GetTotal();

    canvas = document.getElementById('canvas');
    ctx = canvas.getContext('2d');
    ctx.clearRect(0, 0, canvas.width, canvas.height);

    CreateText();

    for (var i = 0; i < myData.length; i++) {
        ctx.fillStyle = pieColors[i];
        ctx.beginPath();
        ctx.moveTo(160, 75);
        ctx.arc(160, 75, 75, lastend, lastend +
            (Math.PI * 2 * (myData[i] / myTotal)), false);
        ctx.lineTo(160, 75);
        ctx.fill();
        lastend += Math.PI * 2 * (myData[i] / myTotal);
        ctx.arc(160, 75, 40, 0, Math.PI * 2);
    }

    // either change this to the background color,CalculateTestsStatuses or use the global composition
    ctx.globalCompositeOperation = "destination-out";
    ctx.beginPath();
    ctx.moveTo(160, 35);
    ctx.arc(160, 75, 40, 0, Math.PI * 2);
    ctx.fill();
    ctx.closePath();
    // if using the global composition method, make sure to change it back to default.
    ctx.globalCompositeOperation = "source-over";
}

function CreateText() {
    var canvas;
    var ctx;
    var textPosY = 50;
    var textPosX = 0;

    canvas = document.getElementById("canvas");
    ctx = canvas.getContext("2d");
    ctx.clearRect(0, 0, canvas.width, canvas.height);

    for (var i = 0; i < myData.length; i++) {
        ctx.fillStyle = pieColors[i];
        ctx.font = "15px arial";
        ctx.fillText(myParsedData[i], textPosX, textPosY);
        textPosY += 35;
    }
}

var allPassed = 0;
var allFailed = 0;
var allWarns = 0;

var myData = [];

var myParsedData = [];


function CreateTotalStatusesGraph() {

    var totalTests = allPassed + allFailed + allWarns;
    var passedPrec = (allPassed / totalTests) * 100;
    var failedPrec = (allFailed / totalTests) * 100;
    var warnPrec = (allWarns / totalTests) * 100;

    passedPrec = passedPrec.toFixed(2).replace("/\.(\d\d)\d?$/", '.$1');
    failedPrec = failedPrec.toFixed(2).replace("/\.(\d\d)\d?$/", '.$1');
    warnPrec = warnPrec.toFixed(2).replace("/\.(\d\d)\d?$/", '.$1');

    //document.getElementById("TotalFailedDiv").style.width = failedPrec + "%";
    //document.getElementById("TotalPassedDiv").style.width = passedPrec + "%";
    //document.getElementById("TotalWarnDiv").style.width = warnPrec + "%";

    //document.getElementById("TotalFailedDiv").title = allFailed + "(" + failedPrec + "%)";
    //document.getElementById("TotalPassedDiv").title = allPassed + "(" + passedPrec + "%)";
    //document.getElementById("TotalWarnDiv").title = allWarns + "(" + warnPrec + "%)";

    document.getElementById("TotalFailedText").innerHTML = allFailed + "(" + failedPrec + "%)";;
    document.getElementById("TotalPassedText").innerHTML = allPassed + "(" + passedPrec + "%)";;
    document.getElementById("TotalWarnText").innerHTML = allWarns + "(" + warnPrec + "%)";;
}

function CalculateTotalPrecents() {

    var totalTests = allPassed + allFailed + allWarns;
    var passedPrec = (allPassed / totalTests) * 100;
    var failedPrec = (allFailed / totalTests) * 100;
    var warnPrec = (allWarns / totalTests) * 100;

    myData.push(passedPrec);
    myData.push(failedPrec);
    myData.push(warnPrec);

    myParsedData.push(allPassed + " (" + Math.round(passedPrec).toFixed(2) + "%)");
    myParsedData.push(allFailed + " (" + Math.round(failedPrec).toFixed(2) + "%)");
    myParsedData.push(allWarns + " (" + Math.round(warnPrec).toFixed(2) + "%)");

    document.getElementById('dataViewer').innerHTML = "<tr class='odd'><td><canvas id='canvas' width='240' height='150'>This text is displayed if your browser does not support HTML5 Canvas.</canvas></td></tr>";
    CreatePie();
    AddEventListener();
}

function CalculateTestsStatuses(testContaineId, classId) {
    var totalPassed = 0;
    var totalFailed = 0;
    var totalInconclusive = 0;
    var e = document.getElementById(testContaineId);
    var tests = e.getElementsByClassName('Test');
    for (var i = 0; i < tests.length; i++) {
        var test = tests[i];
        if (test.getElementsByClassName('warn').length > 0) {
            totalInconclusive++;
            allWarns++;
        }
        else if (test.getElementsByClassName('failed').length > 0) {
            totalFailed++;
            allFailed++;
        }
        else if (test.getElementsByClassName('passed').length > 0) {
            totalPassed++;
            allPassed++;
        }
    }

    var totalTests = totalFailed + totalInconclusive + totalPassed;
    var passedPrec = (totalPassed / totalTests) * 100;
    var failedPrec = (totalFailed / totalTests) * 100;
    var warnPrec = (totalInconclusive / totalTests) * 100;

    passedPrec = passedPrec.toFixed(2).replace("/\.(\d\d)\d?$/", '.$1');
    failedPrec = failedPrec.toFixed(2).replace("/\.(\d\d)\d?$/", '.$1');
    warnPrec = warnPrec.toFixed(2).replace("/\.(\d\d)\d?$/", '.$1');

    document.getElementById(classId + "Failed").style.width = failedPrec + "%";
    document.getElementById(classId + "Passed").style.width = passedPrec + "%";
    document.getElementById(classId + "Warn").style.width = warnPrec + "%";

    document.getElementById(classId + "Failed").title = totalFailed + "(" + failedPrec + "%)";
    document.getElementById(classId + "Passed").title = totalPassed + "(" + passedPrec + "%)";
    document.getElementById(classId + "Warn").title = totalInconclusive + "(" + warnPrec + "%)";
}
