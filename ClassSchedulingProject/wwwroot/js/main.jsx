'use strict'

const AllEvents = ReactDOM.createRoot(document.getElementById("allEvents"));
AllEvents.render(<EventListComponent i={newCalender.data}  type={"EventList"} />);

const FilteredEventsList = ReactDOM.createRoot(document.getElementById("filteredEvents"))
FilteredEventsList.render(<EventListComponent i={newCalender.data} type={"FilteredEvents"} />);
const EventTemplates = ReactDOM.createRoot(document.getElementById("EventTemplates"));
EventTemplates.render(<EventTemplateComponent CourseOfferings={caldata.EventTemplates} />);
function changeView(e, callback){
    if(developerMode) console.log("hello");
    if(e.value === "2"){
        document.getElementById("calendar").style.setProperty("display", "none");
        document.getElementById("panel2").style.setProperty("display", "none");
        document.getElementById("panel1").classList.remove("col-lg-7");
        document.getElementById("panel1").classList.add("col-lg-12");
        document.getElementById("listView").style.setProperty("display", "block");
        const listViewRoot = ReactDOM.createRoot(document.getElementById("listView"));
        if(developerMode) console.log(newCalender.data.events);
        listViewRoot.render(<ListViewComponent i={newCalender.data} />);
    }else{
        document.getElementById("listView").style.setProperty("display", "none");
        document.getElementById("calendar").style.setProperty("opacity", "0");
        document.getElementById("calendar").style.setProperty("display", "");
        document.getElementById("panel1").classList.remove("col-lg-12");
        document.getElementById("panel1").classList.add("col-lg-7");
        fetchData(new Object, function(){
            document.getElementById("panel2").style.setProperty("display", "");
            document.getElementById("calendar").style.setProperty("opacity", "1");
            if(callback) callback();
        });
    }
}
