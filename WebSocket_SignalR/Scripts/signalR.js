//immediately invoked function
(function () {
    var con = $.connection.hub;
    var socketHub = $.connection.socketHub;
    console.log(con);
    if (socketHub.connection.state === 4) { //connect only if disconnected 
        con.start({ transport: $.signalR.transports.webSockets.name }) //start using WEBSOCKETS transport
        .done(function () {
            $("body").css("background-color", "green");
            socketHub.server.browserLanguage(userLang = navigator.language || navigator.userLanguage)
            .done(function (data) { console.log("Server response: " + data); })
            .fail(function () { console.log("failed send browserlanguage"); });
        })
        .fail(function () { $("body").css("background-color", "red"); console.log("connection failed!"); });
    }
    con.stateChanged(connectionStateChanged);
    //CLIENT FUNCTIONS
    socketHub.client.onReceivedConnectedClientsList = function (clients) { console.log(clients);}
    socketHub.client.onMessage = function (msg) { $("#board").append("<li>" + msg + "</li>"); console.log(msg); }
    socketHub.client.getJson = function (msg) { console.log(msg); $("#time").text(msg);}




    //global functions
    function connectionStateChanged(state) {
        var stateConversion = { 0: 'connecting', 1: 'connected', 2: 'reconnecting', 4: 'disconnected' };
        console.log('SignalR state changed from: ' + stateConversion[state.oldState]
         + ' to: ' + stateConversion[state.newState]);
        switch (state.newState) {
            case 0: { $("body").css("background-color", "lightgreen"); break; }
            case 1: { $("body").css("background-color", "green"); break; }
            case 2: { $("body").css("background-color", "orange"); break; }
            case 4: { $("body").css("background-color", "red"); break; }
            default: break;
        }
    }
    
})()