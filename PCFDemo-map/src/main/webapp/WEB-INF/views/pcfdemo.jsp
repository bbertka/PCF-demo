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
          <!-- <li><a href="https://keen.io">Instance hosted at &nbsp;<%=request.getLocalAddr() %>:<%=request.getLocalPort() %></a></li> -->
        </ul>
       </div>
    </div>
  </div>
  
  <!-- Begin page content -->  
  <div class="container-fluid tester123">
    <div class="row">


      <!-- Begin Left Column content -->  
      <div class="col-sm-2" id="left-side-knobs">
      <c:if test="${producerApps != null }">
      	<c:forEach items = "${producerApps}" var="app">
         <!-- Begin Knob content -->  
        <div class="row">
          <div class="col-sm-12">
            <div class="chart-wrapper">
              <div class="chart-title">
                ${app.name}
              </div>
              <div class="chart-stage">
		      	<c:choose>
			  	<c:when test="${app.state != 'STOPPED'}">
                  <input class="knob" data-max="8" data-fgcolor="#3C763D" data-thickness=".2" data-readonly="true" value="${app.instances}" readonly="readonly">
			  	</c:when>
			  	<c:otherwise>
                  <input class="knob" data-max="8" data-fgcolor="#D93D2E" data-thickness=".2" data-readonly="true" value="${app.instances}" readonly="readonly">
			  	</c:otherwise>
		      	</c:choose>  
		      </div>
              <div class="chart-notes">
                Status: ${app.state}
              </div>
            </div>
          </div>
        </div>     	
      	</c:forEach>
      </c:if>
      <!-- End Left Column content -->
      </div>
      
      
      <!-- Begin Center Column content -->  
      <div class="col-sm-8">
      <div class="row">
       <div class="col-sm-12">
        <div class="chart-wrapper">
          <div class="chart-title">
            <b>Activation density per US State (tip: click on a state for details)</b>
          </div>
          <div class="chart-stage">
	          <div id="stateOrders" align="center" ></div>
  		      <div id="usmap" align="center"></div>
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
      </div>

      <!-- Unhide to show environment
      <div class="row">
       <div class="col-sm-12">
        <div class="chart-wrapper">
          <div class="chart-title">
           Debug PCF Instance Environment
          </div>
          <div class="chart-stage">
             <div id="autogenMsg" align="center"> </div><br>
             <div id="environment">Environment Variables etc</div>
	      </div>
          <div class="chart-notes">
		      This box is for debug log messages and such --  will go away for prod deploy
		  </div>
        </div>
      </div>
      </div>
      -->

      </div>
      
      <!-- Begin Right Column content -->  
      <div class="col-sm-2" id="right-side-knobs">

        <!-- Begin Knob content -->


      <!-- End Right Column content -->  
      </div>

    </div>

  <!-- Begin Footer content -->  
     <hr>
      <div class="container-fluid">
      <p>
      <div class="pull-left">&copy;&nbsp;2015 Pivotal Software, Inc.</div>
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
<!--
<script type="text/javascript" src="resources/js/jquery.knob.js"></script>
<script type="text/javascript" src="resources/js/mapknob.js"></script>
-->

</body>
