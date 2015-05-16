var img = [];

function AddToArray(imagesString) {
    img = imagesString.split("|");
    slideimagesRight();
    if (img.length > 1) {
        show("rightArrow");
        show("leftArrow");
    }
    else if (img.length == 1) {
        hide("rightArrow");
        hide("leftArrow");
    }
}

function slideimagesRight() {
    var lastPlace = img[img.length - 1];//Save the last cell 
    for (var i = 1; i < img.length; i++) {
        img[img.length - i] = img[img.length - 1 - i];//Do the replacment,shift left
    }

    img[0] = lastPlace;//Replace first cell with the last cell we stored

    for (var i = 0; i < img.length; i++) {
        updateFloatingImage(img[i]);
    }
}

function slideimagesLeft() {
    var firstPlace = img[0];

    for (var i = 0; i < img.length - 1; i++) {
        img[i] = img[i + 1];
    }

    img[img.length - 1] = firstPlace;

    for (var i = 0; i < img.length; i++) {
        updateFloatingImage(img[i]);
    }
}

function identifyKeyDownEvent(keyEvent) {
    var pressedKeyValue = keyEvent.keyCode;
    if (pressedKeyValue == 27) {//esc
        hide('floatingImageBackground');
        hide('floatingGrayBackground');
    }
    else if (pressedKeyValue == 37) {//left
        slideimagesLeft();
    }
    else if (pressedKeyValue == 39) {//right
        slideimagesRight();
    }
}

