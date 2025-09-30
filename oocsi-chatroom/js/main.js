var loggedIn = false;
var username = '';
var roomname = '';
var $ = jQuery;
var oocsiWS = "WEB_SOCKET_SERVER";

/**
 * console.log for debug 
 * 
 * @param {String} logData 
 */
function logme(logData) {
    console.log(logData);
}

/**
 * check whether the required information is ready
 * 
 * @returns boolean
 */
function readyToJoin() {
    if ($("#room-name").val().trim().length > 0 && $("#user-name").val().trim().length > 0) {
        $('#note-login').text("");
        return true;
    } else {
        $('#note-login').text("Chatroom name or nickname is missing!");
        return false;
    }
}


/**
 * update incoming / self sending message for message window
 * 
 * @param {String} msgUser 
 * @param {String} msgMessage 
 * @param {String} msgTime 
 */
function updateMessage(msgUser, msgMessage, msgTime, isMsgFromMe) {
    let msgClass = isMsgFromMe ? " right" : "";
    let metaClass = isMsgFromMe ? " right text-right" : "";
    // build message component
    let logobj = $("<article></article>").addClass("msg" + msgClass);
    let msgmeta = $("<div></div>").addClass("meta" + metaClass).text(" " + msgUser + " @ " + msgTime);
    let msgbubble = $("<div></div>").addClass("bubble" + msgClass).text(msgMessage);
        
    // construct message node
    logobj.append(msgmeta);
    logobj.append(msgbubble);

    // append message node to chat history
    $("#chat-log").append(logobj);
    logobj[0].scrollIntoView();
}

/**
 * send message to OOCSI and update message to chat window
 */
function sendMessage() {
    // get message and check for length
    let message = $('textarea[name=message]').val();
    if (message.trim().length > 0) {
        let now = (new Date()).toLocaleString();   // ms
        // print message on screen
        let data = {
            "username": username,
            "message": message,
            "ts": now
        };

        // send message to oocsi
        OOCSI.send(roomname, {
            username: username,
            message: message,
            ts: now,
        });
        
        // update message to chat window
        updateMessage(username, message, now, " right")
        
        // reset input field
        $("textarea[name=message]").val("");
    } else {
        // show error message
        $("#note-login").text("Nothing to send!");
    }

    // move focus on input field
    $("textarea[name=message]")[0].focus();
}

// login and start oocsi
function login() {
    // create connection
    OOCSI.connect(oocsiWS);
    loggedIn = true;

    // configuration
    username = $('#user-name').val();
    roomname = $("#room-name").val().trim().length > 0
        ? $("#room-name").val()
        : "oocsi-chat-test";
    
    // subscribe to the channel: roomname
    OOCSI.subscribe(roomname, function (e) {
        updateMessage(e.data.username, e.data.message, e.data.ts, "");
    });
    
    // optional logging to console
    OOCSI.logger(function(msg) {console.log(msg)});
    
    let now = new Date().toLocaleString();

    // announce me in channel
    OOCSI.send(roomname, {
        "username": "System",
        "message": username + " has joined the chat!",
        "ts": now,
    });

    updateMessage("System", username + " has joined the chat!", now, "");
    
    // move focus on input field
    $("textarea[name=message]")[0].focus();
}

function logout() {
    let now = new Date().toLocaleString();
    
    // announce me in channel
    OOCSI.send(roomname, {
        username: "System",
        message: username + " has left the chat!",
        ts: now,
    });
    updateMessage("System", "You has left the chat!", now, "");
    OOCSI.unsubscribe(roomname);
    loggedIn = false;
    $("#note-login").text("You're logged out!");
}

/**
 * click event handle for "Join chat" button
 */
$('#join-chat').click(function(event) {
    event.preventDefault();

    logme("join chat clicked!");
    
    if (!loggedIn) {
        if (readyToJoin()) {
            logme("ready to join!");
            login();
        } else {
            $('#note-login').text("Chatroom name or nickname is missing!");
            $("#user-name")[0].focus();
        }
    } else {
        $("#note-login").text("You're logged in already. Input something to send!");
        $("textarea[name=message]")[0].focus();
    }
});

/**
 * click event handle for "Leave chat" button
 */
$('#leave-chat').click(function(event) {
    event.preventDefault();

    logme("leave chat clicked!");
    
    if (loggedIn) {
        logme("ready to leave!");
        logout();
    } else {
        $('#note-login').text("You're not logged in!");
    }
});

/**
 * click event for "Send Message" button
 */
$('#send-msg').click(function(event) {
    event.preventDefault();
    
    if(loggedIn) {
        // if logged in, send as message
        sendMessage();
        $("textarea[name=message]")[0].focus();
    } else {
        // if not yet logged in, do a login
        $("#join-chat").click();
    }
});

/**
 * click event for "Send Message" button
 */
$('#reset-history').click(function(event) {
    event.preventDefault();

    $('#chat-log').empty();
});
