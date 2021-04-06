/// Exemples de documents.

String html1 = """<header>Démo</header>""";
String html2 = """<!doctype html>
<html lang="fr">
<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Démo</title>
    <style>
    .shell {
  display: grid;
  grid-template-columns: 0 1fr 0;
  grid-template-rows: auto 8em 1fr auto;
}
@media (min-width: 600px) {
  .shell {
    grid-template-columns: 20px 1fr 20px;
  }
}
/* overlap */
.shell:before {
  content: "";
  grid-column: 1/-1;
  grid-row: 1/3;
  background-color: #063;
}
.shell-header {
  grid-column: 2 / 3;
  grid-row: 1 / 2;
  color: #FFF;
  background-color: #063;
  padding: 35px 20px;
}
.shell-body {
  grid-row: 2 / 4;
  grid-column: 2 / 3; 
  min-height: 50vh;
  padding: 20px;
  border-radius: 10px;
  box-shadow:  0px 0px 20px rgba(0, 0, 0, 0.25);
  background-color: #FFF;
}
.shell-footer {
  grid-column: 2/3;
  grid-row: -1;
  padding: 20px; 
}
body {
  margin:0;
  font-family: sans-serif;
}
</style>
</head>
<body>
<div class="shell">
  <header class="shell-header">
      <h1>Overlapping Header with CSS Grid</h1>
  </header>
  <main class="shell-body">
    <h2>Body</h2>
    <p>This design uses CSS grid to create an overlapping header.</p>
  </main>
  <footer class="shell-footer">Footer</footer>
</div>
</body>
</html>""";

String html3 = """<header>Explosive</header>""";
String html4 = """<!doctype html>
<html lang="fr">
<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Explosive</title>
    <style>
* {
	border: 0;
	box-sizing: border-box;
	margin: 0;
	padding: 0;
}
:root {
	font-size: calc(16px + (48 - 16)*(100vw - 320px)/(2560 - 320));
}
body, button {
	font: 1em/1.5 "Hind", sans-serif;
}
body {
	background: #e3e4e8;
	display: flex;
	height: 100vh;
	overflow: hidden;
}
button {
	background: #255ff4;
	border-radius: 0.2em;
	color: #fff;
	cursor: pointer;
	margin: auto;
	padding: 0.5em 1em;
	transition: background .15s linear, color .15s linear;
}
button:focus, button:hover {
	background: #0b46da;
}
button:focus {
	outline: transparent;
}
button::-moz-focus-inner {
	border: 0;
}
button:active {
	transform: translateY(0.1em);
}
.exploding, .exploding:focus, .exploding:hover {
	background: transparent;
	color: transparent;
}
.exploding {
	pointer-events: none;
	position: relative;
	will-change: transform;
	-webkit-user-select: none;
	-moz-user-select: none;
	-ms-user-select: none;
	user-select: none;
}
.particle {
	position: absolute;
	top: 0;
	left: 0;
}
.particle--debris {
	background: #255ff4;
}
.particle--fire {
	border-radius: 50%;
}
@media (prefers-color-scheme: dark) {
	body {
		background: #17181c;
	}
}
    </style>
    <script>
    document.addEventListener("DOMContentLoaded",() => {
	let button = new ExplosiveButton("button");
});
class ExplosiveButton {
	constructor(el) {
		this.element = document.querySelector(el);
		this.width = 0;
		this.height = 0;
		this.centerX = 0;
		this.centerY = 0;
		this.pieceWidth = 0;
		this.pieceHeight = 0;
		this.piecesX = 9;
		this.piecesY = 4;
		this.duration = 1000;
		this.updateDimensions();
		window.addEventListener("resize",this.updateDimensions.bind(this));
		if (document.body.animate)
			this.element.addEventListener("click",this.explode.bind(this,this.duration));
	}
	updateDimensions() {
		this.width = pxToEm(this.element.offsetWidth);
		this.height = pxToEm(this.element.offsetHeight);
		this.centerX = this.width / 2;
		this.centerY = this.height / 2;
		this.pieceWidth = this.width / this.piecesX;
		this.pieceHeight = this.height / this.piecesY;
	}
	explode(duration) {
		let explodingState = "exploding";
		if (!this.element.classList.contains(explodingState)) {
			this.element.classList.add(explodingState);
			this.createParticles("fire",25,duration);
			this.createParticles("debris",this.piecesX * this.piecesY,duration);
		}
	}
	createParticles(kind,count,duration) {
		for (let c = 0; c < count; ++c) {
			let r = randomFloat(0.25,0.5),
				diam = r * 2,
				xBound = this.centerX - r,
				yBound = this.centerY - r,
				easing = "cubic-bezier(0.15,0.5,0.5,0.85)";
			if (kind == "fire") {
				let x = this.centerX + randomFloat(-xBound,xBound),
					y = this.centerY + randomFloat(-yBound,yBound),
					a = calcAngle(this.centerX,this.centerY,x,y),
					dist = randomFloat(1,5);
				new FireParticle(this.element,x,y,diam,diam,a,dist,duration,easing);
			} else if (kind == "debris") {
				let x = (this.pieceWidth / 2) + this.pieceWidth * (c % this.piecesX),
					y = (this.pieceHeight / 2) + this.pieceHeight * Math.floor(c / this.piecesX),
					a = calcAngle(this.centerX,this.centerY,x,y),
					dist = randomFloat(4,7);

				new DebrisParticle(this.element,x,y,this.pieceWidth,this.pieceHeight,a,dist,duration,easing);
			}
		}
	}
}
class Particle {
	constructor(parent,x,y,w,h,angle,distance = 1,className2 = "") {
		let width = `\${w}em`,
			height = `\${h}em`,
			adjustedAngle = angle + Math.PI/2;
		this.div = document.createElement("div");
		this.div.className = "particle";
		if (className2)
			this.div.classList.add(className2);
		this.div.style.width = width;
		this.div.style.height = height;
		parent.appendChild(this.div);
		this.s = {
			x: x - w/2,
			y: y - h/2
		};
		this.d = {
			x: this.s.x + Math.sin(adjustedAngle) * distance,
			y: this.s.y - Math.cos(adjustedAngle) * distance
		};
	}
	runSequence(el,keyframesArray,duration = 1e3,easing = "linear",delay = 0) {
		let animation = el.animate(keyframesArray, {
				duration: duration,
				easing: easing,
				delay: delay
			}
		);
		animation.onfinish = () => {
			let parentCL = el.parentElement.classList;
			el.remove();
			if (!document.querySelector(".particle"))
				parentCL.remove(...parentCL);
		};
	}
}
class DebrisParticle extends Particle {
	constructor(parent,x,y,w,h,angle,distance,duration,easing) {
		super(parent,x,y,w,h,angle,distance,"particle--debris");
		let maxAngle = 1080,
			rotX = randomInt(0,maxAngle),
			rotY = randomInt(0,maxAngle),
			rotZ = randomInt(0,maxAngle);
		this.runSequence(this.div,[
			{
				opacity: 1,
				transform: `translate(\${this.s.x}em,\${this.s.y}em) rotateX(0) rotateY(0) rotateZ(0)`
			},
			{
				opacity: 1,
			},
			{
				opacity: 1,
			},
			{
				opacity: 1,
			},
			{
				opacity: 0,
				transform: `translate(\${this.d.x}em,\${this.d.y}em) rotateX(\${rotX}deg) rotateY(\${rotY}deg) rotateZ(\${rotZ}deg)`
			}
		],randomInt(duration/2,duration),easing);
	}
}
class FireParticle extends Particle {
	constructor(parent,x,y,w,h,angle,distance,duration,easing) {
		super(parent,x,y,w,h,angle,distance,"particle--fire");
		let sx = this.s.x,
			sy = this.s.y,
			dx = this.d.x,
			dy = this.d.y;
		this.runSequence(this.div,[
			{
				background: "hsl(60,100%,100%)",
				transform: `translate(\${sx}em,\${sy}em) scale(1)`
			},
			{
				background: "hsl(60,100%,80%)",
				transform: `translate(\${sx + (dx - sx)*0.25}em,\${sy + (dy - sy)*0.25}em) scale(4)`
			},
			{
				background: "hsl(40,100%,60%)",
				transform: `translate(\${sx + (dx - sx)*0.5}em,\${sy + (dy - sy)*0.5}em) scale(7)`
			},
			{
				background: "hsl(20,100%,40%)"
			},
			{
				background: "hsl(0,0%,20%)",
				transform: `translate(\${dx}em,\${dy}em) scale(0)`
			}
		],randomInt(duration/2,duration),easing);
	}
}
function calcAngle(x1,y1,x2,y2) {
	let opposite = y2 - y1,
		adjacent = x2 - x1,
		angle = Math.atan(opposite / adjacent);
	if (adjacent < 0)
		angle += Math.PI;
	if (isNaN(angle))
		angle = 0;
	return angle;
}
function propertyUnitsStripped(el,property,unit) {
	let cs = window.getComputedStyle(el),
		valueRaw = cs.getPropertyValue(property),
		value = +valueRaw.substr(0,valueRaw.indexOf(unit));
	return value;
}
function pxToEm(px) {
	let el = document.querySelector(":root");
	return px / propertyUnitsStripped(el,"font-size","px");
}
function randomFloat(min,max) {
	return Math.random() * (max - min) + min;
}
function randomInt(min,max) {
	return Math.round(Math.random() * (max - min)) + min;
}
    </script>
</head>
<body>
<button type="button">Explode</button>
</body>
</html>""";

String html5 = """<header>Employee Information</header>""";
String html6 = """<!doctype html>
<html lang="fr">
<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Employee Information</title>
    <style>*, *:before, *:after {
  -moz-box-sizing: border-box;
  -webkit-box-sizing: border-box;
  box-sizing: border-box;
}
body {
  font-family: 'Nunito', sans-serif;
  color: #384047;
}
table {
  max-width: 960px;
  margin: 10px auto;
}
caption {
  font-size: 1.6em;
  font-weight: 400;
  padding: 10px 0;
}
thead th {
  font-weight: 400;
  background: #8a97a0;
  color: #FFF;
}
tr {
  background: #f4f7f8;
  border-bottom: 1px solid #FFF;
  margin-bottom: 5px;
}
tr:nth-child(even) {
  background: #e8eeef;
}
th, td {
  text-align: left;
  padding: 20px;
  font-weight: 300;
}
tfoot tr {
  background: none;
}
tfoot td {
  padding: 10px 2px;
  font-size: 0.8em;
  font-style: italic;
  color: #8a97a0;
}
</style>
</head>
<body>
<table>
    <caption>Employee Information</caption>
    <thead>
    <tr>
        <th scope="col">Name</th>
        <th scope="col">E-mail</th>
        <th scope="col">Job role</th>
    </tr>
    </thead>
    <tfoot>
    <tr>
        <td colspan="3">Data is updated every 15 minutes.</td>
    </tr>
    </tfoot>
    <tbody>
    <tr>
        <th scope="row">Nick Pettit</th>
        <td>nick@example.com</td>
        <td>Web Designer</td>
    </tr>
    <tr>
        <th scope="row">Andrew Chalkley</th>
        <td>andrew@example.com</td>
        <td>Front-End Developer</td>
    </tr>
    <tr>
        <th scope="row">Dave McFarland</th>
        <td>dave@example.com</td>
        <td>Front-End Developer</td>
    </tr>
    <tr>
        <th scope="row">Guil Hernandez</th>
        <td>guil@example.com</td>
        <td>Web Designer</td>
    </tr>
    </tbody>
</table>
</body>
</html>""";

String html7 = """<header>Pricing Table</header>""";
String html8 = """<!doctype html>
<html lang="fr">
<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Pricing Table</title>
    <style>* {
	 margin: 0;
	 padding: 0;
}
 .cf:before, .pricing-table:before, .cf:after, .pricing-table:after {
	 content: ".";
	 display: block;
	 height: 0;
	 overflow: hidden;
}
 .cf:after, .pricing-table:after {
	 clear: both;
}
 .cf, .pricing-table {
	 zoom: 1;
}
 body {
	 font: 16px/28px;
	 font-weight: lighter;
	 background-color: #90a4ae;
}
 strong {
	 font-weight: bold;
}
 h1, h2, h3, h4, h5, h6 {
	 font-weight: lighter;
}
 .wrap {
	 width: 900px;
	 margin: 70px auto;
	 color: #607d8b;
	 box-shadow: 1px 1px 10px #424242;
}
 .pricing-table .plan {
	 box-sizing: border-box;
	 width: 300px;
	 background-color: #fff;
	 float: left;
	 text-align: center;
	 position: relative;
	 z-index: 10;
}
 .pricing-table .plan h3.name {
	 font-size: 20px;
	 background-color: #546e7a;
	 padding: 15px;
	 color: #fff;
}
 .pricing-table .plan h4.price {
	 font-size: 49px;
	 color: #fff;
	 padding: 30px;
	 background-color: #01a4f5;
	 line-height: 40px;
}
 .pricing-table .plan h4.price span {
	 font-size: 16px;
	 font-style: italic;
}
 .pricing-table .plan ul.details {
	 list-style-type: none;
}
 .pricing-table .plan ul.details li {
	 border-bottom: 1px solid #b3b9c4;
	 padding: 15px;
}
 .pricing-table .plan h5.order {
	 padding: 30px;
	 font-size: 17px;
}
 .pricing-table .plan h5.order a {
	 text-decoration: none;
	 color: #fff;
	 background-color: #01a4f5;
	 padding: 10px 20px;
}
 .pricing-table .plan:first-child h4.price {
	 background-color: #0ec0a5;
}
 .pricing-table .plan:first-child h5.order a {
	 background-color: #0ec0a5;
}
 .pricing-table .plan:last-child h4.price {
	 background-color: #f22d47;
}
 .pricing-table .plan:last-child h5.order a {
	 background-color: #f22d47;
}
 .pricing-table .plan:nth-child(2n) {
	 box-shadow: 0px 0px 10px #424242;
	 z-index: 100;
}
 </style>
</head>
<body>
<div class="wrap">
    <div class="pricing-table">
        <div class="plan">
            <h3 class="name">Basic</h3>
            <h4 class="price">\$10<span>/month</span></h4>

            <ul class="details">
                <li><strong>1</strong> Database</li>
                <li><strong>10GB</strong> file storage</li>
                <li><strong>100GB</strong> bandwidth</li>
            </ul>

            <h5 class="order"><a href="#">Order Now</a></h5>
        </div><!--.plan-->

        <div class="plan">
            <h3 class="name">Standard</h3>
            <h4 class="price">\$20<span>/month</span></h4>

            <ul class="details">
                <li><strong>2</strong> Databases</li>
                <li><strong>20GB</strong> file storage</li>
                <li><strong>150GB</strong> bandwidth</li>
            </ul>

            <h5 class="order"><a href="#">Order Now</a></h5>
        </div><!--.plan-->

        <div class="plan">
            <h3 class="name">Premium</h3>
            <h4 class="price">\$30<span>/month</span></h4>

            <ul class="details">
                <li><strong>5</strong> Databases</li>
                <li><strong>50GB</strong> file storage</li>
                <li><strong>500GB</strong> bandwidth</li>
            </ul>

            <h5 class="order"><a href="#">Order Now</a></h5>
        </div><!--.plan-->
    </div><!--.pricing-table-->
</div><!--.wrap-->
</body>
</html>""";

String html9 = """<header>Grille</header>""";
String html10 = """<!doctype html>
<html lang="fr">
<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Grille</title>
    <style>
* {
  box-sizing: border-box;
  margin: 0;
  padding: 0;
}
body {
  background: #333;
  color: #fff;
  font-family: 'Roboto', sans-serif;
}
h2 {
  font-size: 45px;
  font-weight: 300;
  margin: 10px;
}
h2 span {
  font-size: 30px;
}
p {
  font-size: 20px;
}
.container {
  display: grid;
  grid-template-columns: repeat(4, 1fr);
  grid-gap: 10px;
}
.container > div {
  cursor: pointer;
  height: 210px;
  background-size: cover;
  background-attachment: fixed;
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  text-align: center;
  transition: all 0.5s ease-in;
}
.container > div:hover {
  opacity: 0.7;
  transform: scale(0.98);
}
.container > div:nth-of-type(1) {
  grid-column: 1 / 3;
}
.container > div:nth-of-type(6) {
  grid-column: 3 / 5;
}
.container > div:nth-of-type(9) {
  grid-column: 3 / 5;
}
.container > div:nth-of-type(10) {
  grid-column: 1 / 3;
}
.bg1 {
  background: url('https://i.ibb.co/dBLbrRV/bg1.jpg');
}
.bg2 {
  background: url('https://i.ibb.co/Fb5jb3J/bg2.jpg');
  color: #333;
}
    </style>
</head>
<body>
<div class="container">
      <div class="bg1">
        <h2>16 <span>| 24</span></h2>
        <p>Goals Completed</p>
      </div>
      <div class="bg1">
        <h2><i class="fas fa-battery-three-quarters"></i></h2>
        <p>Respiration</p>
      </div>
      <div class="bg2">
        <h2><i class="fas fa-running"></i></h2>
        <p>Miles</p>
      </div>
      <div class="bg1">
        <h2>36 &deg;</h2>
        <p>Temperature</p>
      </div>
      <div class="bg1">
        <h2><i class="fas fa-bed"></i></h2>
        <p>Sleep Keep</p>
      </div>
      <div class="bg2">
        <h2>98 <span>bpm</span></h2>
        <p>Heart Rate</p>
      </div>
      <div class="bg1">
        <h2>170 <span>lbs</span></h2>
        <p>Weight</p>
      </div>
      <div class="bg1">
        <h2>28 <span>%</span></h2>
        <p>Fat Percentage</p>
      </div>
      <div class="bg2">
        <h2>118 <span>mgdl</span></h2>
        <p>Blood Glucose</p>
      </div>
      <div class="bg2">
        <h2>680 <span>kcal</span></h2>
        <p>AVG Consumption</p>
      </div>
      <div class="bg2">
        <h2><i class="fas fa-dumbbell"></i></h2>
        <p>Workouts</p>
      </div>
      <div class="bg2">
        <h2>85 <span>%</span></h2>
        <p>Body Hydration</p>
      </div>
    </div>
</body>
</html>""";

String html11 = """<header>Login Form</header>""";
String html12 = """<!doctype html>
<html lang="fr">
<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Login Form</title>
    <style>
    html {
  height: 100%;
}
body {
  margin:0;
  padding:0;
  font-family: sans-serif;
  background: linear-gradient(#141e30, #243b55);
}
.login-box {
  position: absolute;
  top: 50%;
  left: 50%;
  width: 400px;
  padding: 40px;
  transform: translate(-50%, -50%);
  background: rgba(0,0,0,.5);
  box-sizing: border-box;
  box-shadow: 0 15px 25px rgba(0,0,0,.6);
  border-radius: 10px;
}
.login-box h2 {
  margin: 0 0 30px;
  padding: 0;
  color: #fff;
  text-align: center;
}
.login-box .user-box {
  position: relative;
}
.login-box .user-box input {
  width: 100%;
  padding: 10px 0;
  font-size: 16px;
  color: #fff;
  margin-bottom: 30px;
  border: none;
  border-bottom: 1px solid #fff;
  outline: none;
  background: transparent;
}
.login-box .user-box label {
  position: absolute;
  top:0;
  left: 0;
  padding: 10px 0;
  font-size: 16px;
  color: #fff;
  pointer-events: none;
  transition: .5s;
}
.login-box .user-box input:focus ~ label,
.login-box .user-box input:valid ~ label {
  top: -20px;
  left: 0;
  color: #03e9f4;
  font-size: 12px;
}
.login-box form a {
  position: relative;
  display: inline-block;
  padding: 10px 20px;
  color: #03e9f4;
  font-size: 16px;
  text-decoration: none;
  text-transform: uppercase;
  overflow: hidden;
  transition: .5s;
  margin-top: 40px;
  letter-spacing: 4px
}
.login-box a:hover {
  background: #03e9f4;
  color: #fff;
  border-radius: 5px;
  box-shadow: 0 0 5px #03e9f4,
              0 0 25px #03e9f4,
              0 0 50px #03e9f4,
              0 0 100px #03e9f4;
}
.login-box a span {
  position: absolute;
  display: block;
}
.login-box a span:nth-child(1) {
  top: 0;
  left: -100%;
  width: 100%;
  height: 2px;
  background: linear-gradient(90deg, transparent, #03e9f4);
  animation: btn-anim1 1s linear infinite;
}
@keyframes btn-anim1 {
  0% {
    left: -100%;
  }
  50%,100% {
    left: 100%;
  }
}
.login-box a span:nth-child(2) {
  top: -100%;
  right: 0;
  width: 2px;
  height: 100%;
  background: linear-gradient(180deg, transparent, #03e9f4);
  animation: btn-anim2 1s linear infinite;
  animation-delay: .25s
}
@keyframes btn-anim2 {
  0% {
    top: -100%;
  }
  50%,100% {
    top: 100%;
  }
}
.login-box a span:nth-child(3) {
  bottom: 0;
  right: -100%;
  width: 100%;
  height: 2px;
  background: linear-gradient(270deg, transparent, #03e9f4);
  animation: btn-anim3 1s linear infinite;
  animation-delay: .5s
}
@keyframes btn-anim3 {
  0% {
    right: -100%;
  }
  50%,100% {
    right: 100%;
  }
}
.login-box a span:nth-child(4) {
  bottom: -100%;
  left: 0;
  width: 2px;
  height: 100%;
  background: linear-gradient(360deg, transparent, #03e9f4);
  animation: btn-anim4 1s linear infinite;
  animation-delay: .75s
}
@keyframes btn-anim4 {
  0% {
    bottom: -100%;
  }
  50%,100% {
    bottom: 100%;
  }
}
    </style>
</head>
<body>
<div class="login-box">
  <h2>Login</h2>
  <form>
    <div class="user-box">
      <input type="text" name="" required="">
      <label>Username</label>
    </div>
    <div class="user-box">
      <input type="password" name="" required="">
      <label>Password</label>
    </div>
    <a href="#">
      <span></span>
      <span></span>
      <span></span>
      <span></span>
      Submit
    </a>
  </form>
</div>
</body>
</html>""";
