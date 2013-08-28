// This is a test harness for your module
// You should do something interesting in this harness 
// to test out the module and to provide instructions 
// to users on how to use it by example.


// open a single window
var win = Ti.UI.createWindow({
	backgroundColor:'white',
  navBarHidden: false,
  title: "dash test"
});
win.open();

// TODO: write your module tests here
var rudash = require('edu.rutgers.dash');
Ti.API.info("module is => " + rudash);

Ti.API.info("module exampleProp is => " + rudash.exampleProp);
rudash.exampleProp = "This is a test value";

var dashItem = rudash.createDashboardItem({
  label: 'hi',
  badge: 2,
  image: 'bus.png'
});
var dashItem2 = rudash.createDashboardItem({
  label: 'hi',
  badge: 2,
  image: 'news.png'
});

var dashItem2 = rudash.createDashboardItem({
  label: 'hi',
  badge: 2,
  image: 'food.png'
});


var dash = rudash.createDashboardView({
  height: 'fill',
  width: 'fill',
  borderColor: 'black',
  borderWidth: 3,
  data: [dashItem, dashItem2]
});

dash.addEventListener('click', function () {
  alert('clicked');
});

win.add(dash);
