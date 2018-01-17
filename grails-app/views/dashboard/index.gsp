<!DOCTYPE html>
<html>
<head>
    <meta name="layout" content="main" />
    <meta name="layout" content="main" />
    <g:set var="entityName" value="${message(code: 'dashboard.label', default: 'Dashboard')}" />
    <title><g:message code="default.list.label" args="[entityName]" /></title>
    <asset:javascript src="gridstack/gridstack.all.js"/>
    <asset:javascript src="d3/d3.min.js"/>
    <asset:stylesheet src="billboard/billboard.min.css"/>
    <asset:javascript src="billboard/billboard.min.js"/>
    <asset:javascript src="charts/bar.js"/>
    <asset:javascript src="charts/pie.js"/>
    <asset:javascript src="dashboards/dashboard.js"/>
    <asset:javascript src="charts/placeholder-charts.js"/>
    <asset:stylesheet src="gridstack/gridstack.css"/>
    <asset:javascript src="bootstrap/bs-modal-fullscreen.min.js"/>
    <g:set var="entityName" value="${message(code: 'schema.label', default: 'Dashboards')}" />
    <title>Dashboard Home</title>
</head>
<body>

<div class="jumbotron jumbotron-fluid" style="background-image: url(${assetPath(src: 'iris/iris_jumbo_bg.png')});">
    <div class="container-fluid">
        <img class="img-fluid" src="${assetPath(src: 'iris/iris_logo_colour.png')}">
        <h1 class="display-3">Easy Data<br>Visualisation</h1>
        <button id="create-dashboard-btn" type="button" class="btn" href="${createLink(controller: 'dashboard', action: 'create')}">Create</button>
    </div>
</div>

<div id="dashboards-wrapper" class="list-wrapper">
    <h1 id="dashboard-list-header" class="list-header">My Dashboards</h1>
    <g:each in="${dashboards}" var="dashboard" status="i">
        <div class="row list-item-row">
            <span class="list-item-prefix">Dashboard</span>
            <span class="tab"></span>
            <span class="list-item-id tab">${i + 1}</span>
            <span class="tab">-</span>
            <span class="list-item-name" href="${createLink(controller: 'dashboard', action: 'show', params: [id: dashboard.id])}">${dashboard.name}</span>
        </div>
    </g:each>
</div>

<div id="dashboard-area" class="overlay">
    <div class="overlay-content"></div>
</div>

<g:javascript>
    //show creation area when create button is clicked
    $("#create-dashboard-btn").on("click", function(){
        var URL = $(this).attr("href");
        updateContainerHtml(URL, REST.method.post, REST.contentType.json, {}, ".overlay-content");
        openNav();
    });

    /* Open when someone clicks on the span element */
    function openNav() {
       $("#dashboard-area").width("100%");
    }

    /* Close when someone clicks on the "x" symbol inside the overlay */
    function closeNav() {
        $("#dashboard-area").width("0%");
    }

    // show dashboard when clicked on
    $(".list-item-name").on("click", function(){
        var URL = $(this).attr("href");
        updateContainerHtml(URL, REST.method.post, REST.contentType.json, {}, ".overlay-content");
        openNav();
    });
</g:javascript>
</body>
</html>