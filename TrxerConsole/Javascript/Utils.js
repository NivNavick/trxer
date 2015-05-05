
var pieColors = ["#5bab5b", "#d8534f", "#efac4e"];//green,red,yellow

function ShowHideWithChange(id1, id2, textOnHide, textOnShow) {
    if (document.getElementById(id1).className == 'visibleRow') {
        document.getElementById(id2).innerHTML = textOnHide;
        document.getElementById(id1).className = 'hiddenRow';
    }
    else {
        document.getElementById(id2).innerHTML = textOnShow;
        document.getElementById(id1).className = 'visibleRow';
    }
}

function ShowHide(id1) {
    if (document.getElementById(id1).className == 'visibleRow') {
        document.getElementById(id1).className = 'hiddenRow';
    }
    else {
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

function ToggleMessageView(messageText,shortenMessageText, id) {
    var element = document.getElementById(id + "TestMessage");
    var linkElement = document.getElementById(id + "TestMessageLink");
    if (linkElement.innerHTML == "Show More") {
        element.innerHTML = messageText;
        linkElement.innerHTML = "Show Less";
    } else {
        element.innerHTML = shortenMessageText;
        linkElement.innerHTML = "Show More";
    }
}