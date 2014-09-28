using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Security;
using System.Web.SessionState;
using Telerik.Sitefinity.Configuration;
using Telerik.Sitefinity.Abstractions.VirtualPath.Configuration;
using Telerik.Sitefinity.Abstractions.VirtualPath;
using Telerik.Sitefinity.Services;
using Telerik.Sitefinity.Web.Events;
using Telerik.Sitefinity.Abstractions;
using Telerik.Sitefinity.Modules.Ecommerce.Orders.Interfaces;
using Telerik.Microsoft.Practices.Unity;
using SitefinityWebApp.Discounts;
using Telerik.Sitefinity.DynamicModules.Builder;

namespace SitefinityWebApp
{
    public class Global : System.Web.HttpApplication
    {

        protected void Application_Start(object sender, EventArgs e)
        {
            Telerik.Sitefinity.Abstractions.Bootstrapper.Initialized += new EventHandler<Telerik.Sitefinity.Data.ExecutedEventArgs>(Bootstrapper_Initialized);

        }

        protected void Bootstrapper_Initialized(object sender, Telerik.Sitefinity.Data.ExecutedEventArgs args)
        {
            if (args.CommandName == "Bootstrapped")
            {
              ObjectFactory.Container.RegisterType<IOrderCalculator, EcommerceOrderCalculatorCustom>(new TransientLifetimeManager(), new InjectionConstructor());
            }
        }

        protected void Session_Start(object sender, EventArgs e)
        {

        }

        protected void Application_BeginRequest(object sender, EventArgs e)
        {

        }

        protected void Application_AuthenticateRequest(object sender, EventArgs e)
        {

        }

        protected void Application_Error(object sender, EventArgs e)
        {

        }

        protected void Session_End(object sender, EventArgs e)
        {

        }

        protected void Application_End(object sender, EventArgs e)
        {

        }
    }
}