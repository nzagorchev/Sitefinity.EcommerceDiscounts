using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Web;
using System.Web.UI.WebControls;
using Telerik.Sitefinity.Ecommerce.Orders.Model;
using Telerik.Sitefinity.Modules.Ecommerce;
using Telerik.Sitefinity.Modules.Ecommerce.Orders;
using Telerik.Sitefinity.Modules.Ecommerce.Orders.Web.UI;
using Telerik.Sitefinity.Security;

namespace SitefinityWebApp.Discounts
{
    public class MyDiscountList : DiscountList
    {
        protected override void OnPreRender(EventArgs e)
        {
            var calc = new DiscountCalculatorCustom();
            var ordersManager = OrdersManager.GetManager();
            CartOrder shoppingCart = GetShoppingCartForUser(ordersManager);
            var items = new List<CartDiscount>();
            if (shoppingCart.UserId != null && shoppingCart.UserId != Guid.Empty)
            {
                var user = UserManager.GetManager().GetUser((Guid)shoppingCart.UserId);
                var roles = RoleManager.GetManager().GetRolesForUser(user.Id).ToList();
                items = calc.GetNotApplicableCartDiscounts(shoppingCart, shoppingCart.SubTotalDisplay, user, roles).ToList();
            }
            else
            {
                items = calc.GetNotApplicableCartDiscounts(shoppingCart, shoppingCart.SubTotalDisplay, null, null).ToList();
            }
            if (items != null && items.Count > 0)
            {
                var sb = new StringBuilder();
                sb.Append("The following discounts are not applicable:");
                foreach (var item in items)
                {
                    sb.Append(item.Title);
                    sb.Append(", ");
                }
                sb.Length -= 2;
                this.MessageLabel.Text = sb.ToString();
            }

            base.OnPreRender(e);
        }

        public Guid GetShoopingCartId()
        {
            HttpCookie shoppingCartCookie = HttpContext.Current.Request.Cookies[EcommerceConstants.OrdersConstants.ShoppingCartIdCookieName];

            if (shoppingCartCookie == null || string.IsNullOrWhiteSpace(shoppingCartCookie.Value))
                return Guid.Empty;

            if (!shoppingCartCookie.Value.IsGuid())
                throw new InvalidOperationException("cartOrderId string cannot be parsed as a GUID; please provide a valid cartOrderId value.");

            return new Guid(shoppingCartCookie.Value);
        }

        public CartOrder GetShoppingCartForUser(OrdersManager ordersManager)
        {
            Guid shoppingCartId = GetShoopingCartId();
            CartOrder shoppingCart = ordersManager.TryGetCartOrder(shoppingCartId);

            if (shoppingCart == null)
            {
                shoppingCartId = Guid.NewGuid();
                shoppingCart = ordersManager.CreateCartOrder(shoppingCartId, null);
            }

            return shoppingCart;
        }

        public override string LayoutTemplatePath
        {
            get
            {
                return MyDiscountList.layoutTemplatePath;
            }
            set
            {
                base.LayoutTemplatePath = value;
            }
        }

        protected virtual Label MessageLabel
        {
            get
            {
                return this.Container.GetControl<Label>("MessageLabel", true);
            }
        }

        private static readonly string layoutTemplatePath = "~/Discounts/MyDiscountListTemplate.ascx";
    }
}