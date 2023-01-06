
var myColor = ["#c0eec0", "#fed9d9", "#FBE87E"];//green,red,yellow
var myStrokeColor = ["#7CCD7C", "#d42945", "#ffcc00"];

function ShowHide(id1, id2, textOnHide, textOnShow) {
    if (document.getElementById(id1).className == 'visibleRow') {
        document.getElementById(id2).innerHTML = textOnHide;
        document.getElementById(id1).className = 'hiddenRow';
    }
    else {
        document.getElementById(id2).innerHTML = textOnShow;
        document.getElementById(id1).className = 'visibleRow';
    }
}

function AddEventListener() {
    var button = document.getElementById('btn-download');
    button.addEventListener('click', function () {
        button.href = canvas.toDataURL('image/png');
    });
}

function show(id) {
    document.getElementById(id).style.visibility = "visible";
    document.getElementById(id).style.display = "block";
}
function hide(id) {

    document.getElementById(id).style.visibility = "hidden";
    document.getElementById(id).style.display = "none";
}

function updateFloatingImage(url) {
    document.getElementById('floatingImage').src = url;
}

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

function CreateHorizontalBars(id, totalPass, totalFailed, totalWarn) {

    if (isNaN(totalPass) || isNaN(totalFailed) || isNaN(totalWarn)) {
        drawLine(30, 4.5, 3, 30.5, id);
    }
    var canvas;
    var ctx;
    var myArray = new Array(3);
    myArray[0] = totalPass;
    myArray[1] = totalFailed;
    myArray[2] = totalWarn;

    canvas = document.getElementById(id);
    ctx = canvas.getContext("2d");

    var cw = canvas.width;
    var ch = canvas.height;

    var width = 6;
    var currX = -12;

    ctx.translate(cw / 2, ch / 2);

    ctx.rotate(Math.PI / 2);

    ctx.restore();

    for (var i = 0 ; i < myArray.length; i++) {
        ctx.moveTo(100, 0);
        ctx.fillStyle = myColor[i];
        var h = myArray[i];
        ctx.fillRect(currX, (canvas.height - h) + 25, width, h);
        currX += width + 1;
    }
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
        ctx.fillStyle = myColor[i];
        ctx.beginPath();
        ctx.moveTo(160, 75);
        ctx.arc(160, 75, 75, lastend, lastend +
            (Math.PI * 2 * (myData[i] / myTotal)), false);
        ctx.lineTo(160, 75);
        ctx.fill();
        lastend += Math.PI * 2 * (myData[i] / myTotal);
        ctx.arc(160, 75, 40, 0, Math.PI * 2);
    }

    // either change this to the background color, or use the global composition
    ctx.globalCompositeOperation = "destination-out";
    ctx.beginPath();
    ctx.moveTo(160, 35);
    ctx.arc(160, 75, 40, 0, Math.PI * 2);
    ctx.fill();
    ctx.closePath();
    // if using the global composition method, make sure to change it back to default.
    ctx.globalCompositeOperation = "source-over";
}

function drawLine(x1, y1, x2, y2, id) {
    var canvas = document.getElementById(id);
    var context = canvas.getContext("2d");

    for (var i = 0; i < 8; i++) {
        context.fillStyle = '#000';
        context.strokeStyle = '#B0B0B0';

        context.beginPath();
        context.moveTo(x1, y1);
        context.lineTo(x2, y2);
        context.lineWidth = 1;
        context.stroke();
        context.closePath();
        x1 += 10;
        y2 += 10;
    }
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
        ctx.fillStyle = myStrokeColor[i];
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

function CalculateTestsStatuses(testContaineId, canvasId) {
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


    CreateHorizontalBars(canvasId, passedPrec, failedPrec, warnPrec);
}

/**
 * Remove assembly name from function name.
 * @param {string} asm 
 * @returns 
 */
function RemoveAssemblyName(asm) {
    var idx = asm.indexOf(',');
    if (idx == -1)
        return asm;
    return asm.substring(0, idx);
}

/**
 * Return input date in short date form.
 * @param {string} date 
 * @returns 
 */
function GetShortDateTime(date) {
    if (!date) {
        return "";
    }
    return new Date(date).toLocaleDateString();
}

/**
 * Return formatted duration in readable display text.
 * 
 * @overload
 * @param {string} duration
 */
/**
 * Return formatted duration in readable display text.
 * 
 * @overload
 * @param {string} start
 * @param {string} finish
 */
function ToExactTimeDefinition() {
    var ms = 0;

    if (arguments.length == 1) {
        var duration = arguments[0];
        var parts = duration.split(':');
        ms = parseFloat(parts[0]) * 60 * 60 * 1000 + parseFloat(parts[1]) * 60 * 1000 + parseFloat(parts[2]) * 1000;
    }
    else if (arguments.length == 2) {
        var start = arguments[0];
        var finish = arguments[1];
        ms = new Date(finish) - new Date(start);
    }

    if (ms < 1000)
        return ms.toFixed(2) + " msec";

    if (ms >= 1000 && ms < 60000)
        return (ms/1000).toFixed(2) + " sec";

    if (ms >= 60000 && ms < 3600000)
        return (ms/1000/60).toFixed(2) + " min";

    return (ms/1000/60/60).toFixed(2) + " hr";
}

/**
 * Return the current datetime as string.
 */
function CurrentDateTime() {
    return new Date().toString();
}

/**
 * Extract image url from input text.
 * @param {string} text 
 */
function ExtractImageUrl(text) {
    var match = /['"][^\s]+(\.(jpg|png|gif|bmp))['"]/i.exec(text);
    if (match.length > 0) {
        return match[0].replace("\'", "").replace("\"", "").replace("\\","\\\\");
    }
    return null;
}
