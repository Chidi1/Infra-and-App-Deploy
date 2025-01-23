using System;
using Microsoft.AspNetCore;
using Microsoft.AspNetCore.Hosting;

namespace aspnet_core_dotnet_core
{
    public class Program
    {
        public static void Main(string[] args)
        {
            CreateWebHostBuilder(args).Build().Run();
        }

        public static IWebHostBuilder CreateWebHostBuilder(string[] args) =>
            WebHost.CreateDefaultBuilder(args)
                .UseStartup<Startup>()
                .UseUrls("http://0.0.0.0:4000");  // Ensures it listens on all IPs
    }
}

