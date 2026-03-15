$(document).ready(function(){
    $("#shoutbutton").click(function() {
        var pesanVal = $("#msg").val();
        if (pesanVal.trim() === "") {
            alert("Silakan ketik pesan terlebih dahulu!");
            return;
        }
        $.ajax({
            type: "GET",
            url: "reply.php",
            data: $("#form1").serialize(),
            success: function(rsp) {
                $("#data").append("<div>"+rsp+"</div>");
                $("#msg").val("");
            },
            error: function(rsp) {
                alert("Error: " + rsp.statusText);
            }
        });
    });

    // Allow Enter key to trigger shout
    $("#msg").keypress(function(e) {
        if (e.which === 13) {
            e.preventDefault();
            $("#shoutbutton").click();
        }
    });
});
