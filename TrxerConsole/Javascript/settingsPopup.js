function toggle(div_id) {
    var el = document.getElementById(div_id);
    if (el.style.display == 'none') { el.style.display = 'block'; }
    else { el.style.display = 'none'; }
}
function blanket_size(popUpDivVar) {
    if (typeof window.innerWidth != 'undefined') {
        viewportheight = window.innerHeight;
    } else {
        viewportheight = document.documentElement.clientHeight;
    }
    if ((viewportheight > document.body.parentNode.scrollHeight) && (viewportheight > document.body.parentNode.clientHeight)) {
        blanket_height = viewportheight;
    } else {
        if (document.body.parentNode.clientHeight > document.body.parentNode.scrollHeight) {
            blanket_height = document.body.parentNode.clientHeight;
        } else {
            blanket_height = document.body.parentNode.scrollHeight;
        }
    }
    var blanket = document.getElementById('blanket');
    blanket.style.height = blanket_height + 'px';
    var popUpDiv = document.getElementById(popUpDivVar);
    popUpDiv_height = blanket_height / 2 - 200;//200 is half popup's height
    //popUpDiv.style.top = popUpDiv_height + 'px';
}
function window_pos(popUpDivVar) {
    if (typeof window.innerWidth != 'undefined') {
        viewportwidth = window.innerHeight;
    } else {
        viewportwidth = document.documentElement.clientHeight;
    }
    if ((viewportwidth > document.body.parentNode.scrollWidth) && (viewportwidth > document.body.parentNode.clientWidth)) {
        window_width = viewportwidth;
    } else {
        if (document.body.parentNode.clientWidth > document.body.parentNode.scrollWidth) {
            window_width = document.body.parentNode.clientWidth;
        } else {
            window_width = document.body.parentNode.scrollWidth;
        }
    }
    var popUpDiv = document.getElementById(popUpDivVar);
    window_width = window_width / 2 - 200;//200 is half popup's width
    popUpDiv.style.left = window_width + 'px';
}
function popup(windowname) {
    blanket_size(windowname);
    window_pos(windowname);
    //  toggle('blanket');
    toggle(windowname);
}

function toggleCheckbox(element) {
    var checkbox = element;
    if (checkbox.className == "Checked") {
        checkbox.className = "UnChecked";
    } else {
        checkbox.className = "Checked";
    }
    updateViewBasedOnSettings(checkbox.id);
    updateLocalStorage(checkbox.id, document.getElementById(checkbox.id + "Element").style.display);
}

function toggleStatusesCheckbox(element) {
    var checkbox = element;
    if (checkbox.className == "Checked") {
        checkbox.className = "UnChecked";
        FilterTestsByStatuses(element.title, "none");
        updateLocalStorage(checkbox.id, "none");
    } else {
        checkbox.className = "Checked";
        FilterTestsByStatuses(element.title, "table-row");
        updateLocalStorage(checkbox.id, "table-row");
    }


}

function updateLocalStorage(id, value) {
    localStorage.setItem(id, value);
}

function updateViewBasedOnSettings(id) {
    var element = document.getElementById(id + "Element");
    if (element.style.display == "none") {
        document.getElementById(id + "Element").style.display = "block";
    } else {
        document.getElementById(id + "Element").style.display = "none";
    }
}

function FilterTestsByStatuses(status, display) {
    var elements = document.getElementsByClassName(status);
    for (var j = 0; j < elements.length; j++) {
        elements[j].parentNode.style.display = display;
    }
}

function ShowStatusesLocalStorgeValues() {
    var elementsNames =
    [
        "failedTestsStatuses",
        "passedTestsStatuses",
        "warnTestsStatuses"
    ];

    for (var i = 0; i < elementsNames.length; i++) {
        var localStorageData = localStorage.getItem(elementsNames[i]);
        var checkbox = document.getElementById(elementsNames[i]);
        FilterTestsByStatuses(checkbox.title, localStorageData);
        UpdateCheckboxState(checkbox, localStorageData);
    }
}

function ShowLocalStorgeValues() {


    var elementsNames =
    [
        "failedTests",
        "testsByClasses",
        "mostSlowest",
        "summaryTables",
        "TotalTests",
        "testStatuses",
        "testDetails"
    ];

    for (var i = 0; i < elementsNames.length; i++) {
        var localStorageData = localStorage.getItem(elementsNames[i]);
        document.getElementById(elementsNames[i] + "Element").style.display = localStorageData;
        var checkbox = document.getElementById(elementsNames[i]);
        UpdateCheckboxState(checkbox, localStorageData);
    }
}

function UpdateCheckboxState(checkbox, localStorageData) {
    if (localStorageData == "none") {
        checkbox.className = "UnChecked";
    } else {
        checkbox.className = "Checked";
    }
}