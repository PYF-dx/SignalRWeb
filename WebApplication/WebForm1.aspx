<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="WebForm1.aspx.cs" Inherits="WebApplication.WebForm1" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <title></title>
    <script src="Scripts/jquery-3.3.1.min.js"></script>
    <script src="Scripts/jquery.signalR-2.4.1.min.js"></script>
    <script src='<%: ResolveClientUrl("~/signalr/hubs") %>'></script>
</head>
<body>
    <label>在线人数:</label><span id="rs">0</span><br />
    <input type="text" id="name" />
    <input type="button" id="dl" value="登录" /><br />
    <select id="mb">
        <option value="">请选择</option>
    </select>
    <input type="text" id="val" />
    <input type="button" id="fs" value="发送" />
    <br />
    <div id="lt">
    </div>
    <script>
        var chat;
        $(function () {
            chat = $.connection.ChatRoomHub;

            //添加用户
            chat.client.NotifyUserEnter = function (nickName, users) {
                buildUserTemplate(nickName, users);
            }

            //用户离开
            chat.client.NotifyUserLeft = function (nickName, users) {
                buildUserTemplate(nickName, users);
            }

            chat.client.NotifySendMessage = function (nickName, message) { NotifySendMessage(nickName, message) }
            //用户列表
            function buildUserTemplate(nickName, users) {
                $("#rs").text(users.length);
                $("#mb").empty();
                var txt = '<option value="">请选择</option>';
                $.each(users, function (e, v) {
                    txt += '<option value="' + v.ConnectionId + '">' + v.NickName + '</option>';
                });
                $("#mb").append(txt);

            }

            function NotifySendMessage(nickName, message) {
                var txt = '<label>' + nickName + ':</label><span id="rs">' + message + '</span><br />';
                $("#lt").append(txt);
            }


        })
        var NameUser;
        $("#dl").click(function () {
            var name = $("#name").val();
            NameUser = name;
            $.connection.hub.start().done(function () {
                chat.server.userEnter(name);
            });
        })
        $("#fs").click(function () {
            var nameId = $("#mb").val();
            var txt = $("#val").val();
            chat.server.sendMessage(NameUser, txt, nameId);
        })
    </script>
</body>

</html>
