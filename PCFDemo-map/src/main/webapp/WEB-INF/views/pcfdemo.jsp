<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page session="false" %>

<html lang="en">
<head>
<meta charset="utf-8">
<meta http-equiv="X-UA-Compatible" content="IE=edge">
<meta name="viewport" content="width=device-width, initial-scale=1">

<title>PCF Demo</title>
<meta http-equiv="Cache-Control" content="no-store, no-cache, must-revalidate, max-age=0">

<!-- Bootstrap core CSS -->
<link href="resources/css/bootstrap.min.css" rel="stylesheet">
<link rel="stylesheet" type="text/css" href="resources/css/keen-dashboards.css" />


<!-- Custom styles for this template -->
<link href="resources/css/sticky-footer-navbar.css" rel="stylesheet">
<link href="resources/css/map.css" rel="stylesheet">
 

<!-- pivotal favicon -->
<link rel="shortcut icon" href="resources/img/favicon.ico"/>

<script type="text/javascript" src="http://ajax.googleapis.com/ajax/libs/jquery/1.9.1/jquery.min.js"></script>
<script type="text/javascript" src="resources/js/jquery.knob.js"></script>
        <script>
            $(function($) {
                $(".knob").knob({
                    change : function (value) {
                        //console.log("change : " + value);
                    },
                    release : function (value) {
                        //console.log(this.$.attr('value'));
                        console.log("release : " + value);
                    },
                    cancel : function () {
                        console.log("cancel : ", this);
                    },
                    /*format : function (value) {
                        return value + '%';
                    },*/
                    draw : function () {
                        // "tron" case
                        if(this.$.data('skin') == 'tron') {
                            this.cursorExt = 0.3;
                            var a = this.arc(this.cv)  // Arc
                                , pa                   // Previous arc
                                , r = 1;
                            this.g.lineWidth = this.lineWidth;
                            if (this.o.displayPrevious) {
                                pa = this.arc(this.v);
                                this.g.beginPath();
                                this.g.strokeStyle = this.pColor;
                                this.g.arc(this.xy, this.xy, this.radius - this.lineWidth, pa.s, pa.e, pa.d);
                                this.g.stroke();
                            }
                            this.g.beginPath();
                            this.g.strokeStyle = r ? this.o.fgColor : this.fgColor ;
                            this.g.arc(this.xy, this.xy, this.radius - this.lineWidth, a.s, a.e, a.d);
                            this.g.stroke();
                            this.g.lineWidth = 2;
                            this.g.beginPath();
                            this.g.strokeStyle = this.o.fgColor;
                            this.g.arc( this.xy, this.xy, this.radius - this.lineWidth + 1 + this.lineWidth * 2 / 3, 0, 2 * Math.PI, false);
                            this.g.stroke();
                            return false;
                        }
                    }
                });
                // Example of infinite knob, iPod click wheel
                var v, up=0,down=0,i=0
                    ,$idir = $("div.idir")
                    ,$ival = $("div.ival")
                    ,incr = function() { i++; $idir.show().html("+").fadeOut(); $ival.html(i); }
                    ,decr = function() { i--; $idir.show().html("-").fadeOut(); $ival.html(i); };
                $("input.infinite").knob(
                                    {
                                    min : 0
                                    , max : 20
                                    , stopper : false
                                    , change : function () {
                                                    if(v > this.cv){
                                                        if(up){
                                                            decr();
                                                            up=0;
                                                        }else{up=1;down=0;}
                                                    } else {
                                                        if(v < this.cv){
                                                            if(down){
                                                                incr();
                                                                down=0;
                                                            }else{down=1;up=0;}
                                                        }
                                                    }
                                                    v = this.cv;
                                                }
                                    });
            });
        </script>
        
</head>

<body class="application">

    <!-- Begin navbar -->
   <div class="navbar navbar-inverse navbar-fixed-top" role="navigation">
    <div class="container-fluid">
      <div class="navbar-header">
        <button type="button" class="navbar-toggle" data-toggle="collapse" data-target=".navbar-collapse">
          <span class="sr-only">Toggle navigation</span>
          <span class="icon-bar"></span>
          <span class="icon-bar"></span>
          <span class="icon-bar"></span>
        </button>
          <a class="navbar-brand" href="#"><img src="resources/img/Comcast_Logo.png" alt="Comcast"></a>
       </div>
       <div class="navbar-collapse collapse">
        <ul class="nav navbar-nav navbar-right">
          <li><a href="https://keen.io">Instance hosted at &nbsp;<%=request.getLocalAddr() %>:<%=request.getLocalPort() %></a></li>
        </ul>
       </div>
    </div>
  </div>
  
  <!-- Begin page content -->  
  <div class="container-fluid tester123">
    <div class="row">
      <div class="col-sm-2">
        <div class="row">
          <div class="col-sm-12">
            <div class="chart-wrapper">
              <div class="chart-title">
                Instance 1 Utilization
              </div>
              <div class="chart-stage">
                  <input class="knob" data-fgcolor="#3C763D" data-thickness=".2" data-readonly="true" value="80" readonly="readonly">
              </div>
              <div class="chart-notes">
                Notes about this chart
              </div>
            </div>
          </div>
        </div>
        <div class="row">
          <div class="col-sm-12">
            <div class="chart-wrapper">
              <div class="chart-title">
                Instance 2 Utilization
              </div>
              <div class="chart-stage">
                  <input class="knob" data-fgcolor="#428DC9" data-thickness=".2"  data-readonly="true" value="75" readonly="readonly">
              </div>
              <div class="chart-notes">
                Notes about this chart
              </div>
            </div>
          </div>
        </div>
        <div class="row">
          <div class="col-sm-12">
            <div class="chart-wrapper">
              <div class="chart-title">
                Instance 3 Utilization
              </div>
              <div class="chart-stage">
                  <input class="knob" data-fgcolor="#64509E" data-thickness=".2" data-readonly="true" value="69" readonly="readonly">
              </div>
              <div class="chart-notes">
                Notes about this chart
              </div>
            </div>
          </div>
        </div>
      </div>
      <div class="col-sm-8">
        <div class="chart-wrapper">
          <div class="chart-title">
            <b>Activation density per US State (tip: click on a state for details)</b>
          </div>
          <div class="chart-stage">
	          <!-- <div id="maincontent"> -->
	          <div id="stateOrders" align="center" ></div>
  		      <div id="usmap" align="center"></div>
	         <!--  </div> -->           
	      </div>
          <div class="chart-notes">
		      <c:choose>
			  <c:when test="${rabbitURI != null}">
				Status: subscriber activation data streaming from RabbitMQ			
			  </c:when>
			  <c:otherwise>
				<b>Status: no RabbitMQ service bound - streaming is not active</b>
			  </c:otherwise>
		      </c:choose>          
		  </div>
        </div>
      </div>
      <div class="col-sm-2">
        <div class="row">
          <div class="col-sm-12">
            <div class="chart-wrapper">
              <div class="chart-title">
                Completed Request
              </div>
              <div class="chart-stage">
                  <input class="knob" data-fgcolor="#9C1F25" data-thickness=".2"  data-readonly="true" value="66" readonly="readonly">
              </div>
              <div class="chart-notes">
                Notes about this chart
              </div>
            </div>
          </div>
        </div>      
        <div class="row">
          <div class="col-sm-12">
            <div class="chart-wrapper">
              <div class="chart-title">
                In-Progress Requests
              </div>
              <div class="chart-stage">
                  <input class="knob" data-fgcolor="#D93D2E" data-thickness=".2"  data-readonly="true" value="52" readonly="readonly">
              </div>
              <div class="chart-notes">
                Notes about this chart
              </div>
            </div>
          </div>
        </div>
        <div class="row">
          <div class="col-sm-12">
            <div class="chart-wrapper">
              <div class="chart-title">
                Reset Requests
              </div>
              <div class="chart-stage">
                  <input class="knob" data-fgcolor="#DFA933" data-thickness=".2" data-readonly="true" value="20" readonly="readonly">
              </div>
              <div class="chart-notes">
                Notes about this chart
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>

  <!-- Begin Footer content -->  
     <hr>
      <div class="container-fluid">
      <p>
      <div class="pull-left">©&nbsp;2015 Pivotal Software, Inc.</div>
      <div class="pull-right"><img src="resources/img/PoweredByPivotal.png" alt="Powered By Pivotal "></div>
      </div>
 
</div>
  
<script type="text/javascript" src="http://ajax.googleapis.com/ajax/libs/jquery/1.9.1/jquery.min.js"></script>

<script type="text/javascript" src="resources/js/bootstrap.min.js"></script>      
<script type="text/javascript" src="http://d3js.org/d3.v2.min.js?2.9.6"></script>
<script type="text/javascript" src="resources/js/rainbowvis.js"></script>
<script type="text/javascript" src="resources/js/histograms.js"></script>
<script type="text/javascript" src="resources/js/map.js"></script>
<script type="text/javascript" src="resources/js/holder.js"></script>
<script type="text/javascript" src="resources/js/keen.min.js"></script>
<script type="text/javascript" src="resources/js/jquery.knob.js"></script>


</body>
