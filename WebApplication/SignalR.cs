using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using System.Web;
using Microsoft.AspNet.SignalR;
using Microsoft.AspNet.SignalR.Hubs;

namespace WebApplication
{
    [HubName("ChatRoomHub")]
    public class SignalR : Hub
    {

        static List<UserEntity> users = new List<UserEntity>();

        /// <summary>
        /// 添加用户
        /// </summary>
        /// <param name="nickName"></param>
        public void UserEnter(string nickName)
        {
            UserEntity userEntity = new UserEntity
            {
                NickName = nickName,
                ConnectionId = Context.ConnectionId
            };

            users.Add(userEntity);
            Clients.All.NotifyUserEnter(nickName, users);//调用前台NotifyUserEnter方法
        }
        List<string> userIdList = new List<string>();
        /// <summary>
        /// 发送消息
        /// </summary>
        /// <param name="nickName"></param>
        /// <param name="message"></param>
        /// <param name="selectUserId"></param>
        public void SendMessage(string nickName, string message, string selectUserId)
        {
            if (!string.IsNullOrEmpty(selectUserId))
            {
                userIdList = selectUserId.Split(',').ToList();
                foreach (string str in userIdList)
                {
                    if (users.Any(c => c.ConnectionId == str))
                    {
                        //只发送用户选中的group
                        //Clients.Group(str, new string[0]).NotifySendMessage(nickName, message);
                        Clients.Client(str).NotifySendMessage(nickName, message);
                    }
                }
            }
            else
            {
                Clients.All.NotifySendMessage(nickName, message);//调用前台NotifySendMessage方法
            }
        }

    }

    public class UserEntity
    {
        public string NickName { get; set; }

        public string ConnectionId { get; set; }
    }
}