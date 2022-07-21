function createDraggableElement(element) {
    dragElement(element);

    function dragElement(element) {
    var x1 = 0, y1 = 0, x2 = 0, y2 = 0;
    element.onmousedown = dragMouseDown;
    element.ontouchstart = touchStart;

        function dragMouseDown(e) {
            e = e || window.event;
        // get the mouse cursor position at startup:
        x2 = e.clientX;
        y2 = e.clientY;
        document.onmouseup = closeDragElement;
        // call a function whenever the cursor moves:
        document.onmousemove = elementDrag;
    }

        function touchStart(e) {
            e = e || window.event;
        x1 = e.targetTouches[0].clientX;
        y1 = e.targetTouches[0].clientY;
        document.ontouchend = closeTouchAndDragElement;
        document.ontouchmove = dragElement;
    }

        function elementDrag(e) {
            e = e || window.event;
        e.preventDefault();
        // calculate the new cursor position:
        x1 = x2 - e.clientX;
        y1 = y2 - e.clientY;
        x2 = e.clientX;
        y2 = e.clientY;
        // set the element's new position:
        element.style.top = (element.offsetTop - y1) + "px";
        element.style.left = (element.offsetLeft - x1) + "px";
    }

        function dragElement(e) {
            e = e || window.event;
        x2 = x1 - e.targetTouches[0].clientX;
        y2 = y1 - e.targetTouches[0].clientY;
        x1 = e.targetTouches[0].clientX;
        y1 = e.targetTouches[0].clientY;
        element.style.top = (element.offsetTop - y2) + "px";
        element.style.left = (element.offsetLeft - x2) + "px";
    }

        function closeDragElement() {
            // stop moving when mouse button is released:
            document.onmouseup = null;
        document.onmousemove = null;
    }
        function closeTouchAndDragElement() {
            document.ontouchend = null;
        document.ontouchmove = null;
    }
}
}