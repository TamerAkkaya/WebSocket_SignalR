<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="default.aspx.cs" Inherits="WebSocket_SignalR._default" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
    <link href="Content/bootstrap.min.css" rel="stylesheet" />
</head>
<body>
    <form id="form1" runat="server">
        <p id="time"></p>
        <progress max="100" value="0"></progress>
        <span>0%</span><br />
    <div id="btnLongRunningTask" class="btn btn-primary">Start Task</div>
        <hr />
        <input id="msgBox" type="text" />
        <div id="btnSendMessage" class="btn btn-info">Send Message To Others</div>
        <ul id="board" style="width:400px;height:200px; background-color:#fff;overflow-y:scroll"></ul>
    </form>
    <script src="Scripts/jquery-1.9.1.min.js"></script>
    <script src="Scripts/bootstrap.min.js"></script>
    <script src="Scripts/jquery.signalR-2.2.1.min.js"></script>
    <script src="http://localhost:53107/signalr/hubs"></script>
    <script src="Scripts/signalR.js"></script>
    <script>
        var setInterval_GetJSON;
        $().ready(function () {
            $("#btnLongRunningTask").on("click", function () {
                var socketHub = $.connection.socketHub;
                if (socketHub.connection.state === 1) {  //if already connected to HUB
                    socketHub.server.doLongRunningThing()
                    .progress(function (update) { $("progress").val(update);$("progress").siblings("span").text(update+"%");console.log(update); })
                    .done(function (data) { console.log(data);});
                }
            });
            $("#btnSendMessage").on("click", function () {
                var socketHub = $.connection.socketHub;
                if (socketHub.connection.state === 1) {  //if already connected to HUB
                    socketHub.server.sendMessage($("#msgBox").val());
                }
            });
            setInterval_GetJSON = setInterval(function () {
                var socketHub = $.connection.socketHub;
                if (socketHub.connection.state === 1) {  //if already connected to HUB
                    socketHub.server.getJson()
                    .done(function (data) { console.log("Server response: " + data); $("#time").text(JSON.parse(data).Time); })
                    .fail(function () { console.log("failed getJson"); });
                }
            }, 1000);
        });

    </script>
</body>
</html>
