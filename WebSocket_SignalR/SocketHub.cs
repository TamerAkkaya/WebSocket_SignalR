using Microsoft.AspNet.SignalR;
using Newtonsoft.Json;
using System;
using System.Collections.Concurrent;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using System.Web;

namespace WebSocket_SignalR
{
    public class SocketHub:Hub<ClientSideFunctions>
    {
        public string BrowserLanguage(string BrowserLanguage)
        {
            return String.Format("Browser language: '{0}'",BrowserLanguage);
        }
        public string GetJson()
        {
            var t = new { Time = DateTime.Now.ToLongTimeString() };
            return JsonConvert.SerializeObject(t);
        }
        public async Task<string> DoLongRunningThing(IProgress<int> progress)
        {
            for (int i = 0; i <= 100; i += 1)
            {
                await Task.Delay(100);
                progress.Report(i);
            }
            return "Job complete!";
        }
        public void SendMessage(string msg)
        {
            Clients.All.OnMessage(String.Format("From {0}: {1}", Context.ConnectionId.Substring(0,4)+"...", msg));
        }
        public override Task OnConnected()
        {
                Global.ConnectedClients.AddOrUpdate(Context.ConnectionId,true,(key,value)=>true);
                Clients.All.OnReceivedConnectedClientsList(Global.ConnectedClients.Where(x => x.Value).Select(x=>x.Key).ToArray());
            return base.OnConnected();
        }
        public override Task OnDisconnected(bool stopCalled)
        {
            Global.ConnectedClients.AddOrUpdate(Context.ConnectionId, false, (key, value) => false);
            Clients.All.OnReceivedConnectedClientsList(Global.ConnectedClients.Where(x=>x.Value).Select(x => x.Key).ToArray());
            return base.OnDisconnected(stopCalled);
        }
        public override Task OnReconnected()
        {

            Global.ConnectedClients.AddOrUpdate(Context.ConnectionId, true, (key, value) => true);
            Clients.All.OnReceivedConnectedClientsList(Global.ConnectedClients.Where(x => x.Value).Select(x => x.Key).ToArray());
            return base.OnReconnected();
        }
    }
    public interface ClientSideFunctions
    {
        void OnReceivedConnectedClientsList(string[] clientCount);
        void OnMessage(string msg);
    }
}