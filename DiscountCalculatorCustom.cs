using System;
using System.Collections.Generic;
using System.Linq;
using System.Linq.Expressions;
using Telerik.Sitefinity.Ecommerce.Orders.Model;
using Telerik.Sitefinity.Modules.Ecommerce.Orders.Business;
using Telerik.Sitefinity.Security;
using Telerik.Sitefinity.Security.Claims;
using Telerik.Sitefinity.Security.Model;

namespace SitefinityWebApp.Discounts
{
    public class DiscountCalculatorCustom : DiscountCalculator
    {
        //public DiscountCalculatorCustom()
        //{
        //    if (removedDiscount == null)
        //    {
        //        removedDiscount = new Dictionary<Guid, IList<CartDiscount>>();
        //    }
        //}

        protected override IList<CartDiscount> GetApplicableCartDiscounts(CartOrder cartOrder, decimal subTotal, User user, List<Role> userRoles)
        {
            var all = base.GetApplicableCartDiscounts(cartOrder, subTotal, user, userRoles);
            var discounts = all;
            if (discounts != null)
            {
                // Get Discount with specific code
                var discount = discounts
                    .Where(d => d.DiscountType == DiscountType.Coupon && d.ParentDiscount.CouponCode.Contains("code"))
                    .FirstOrDefault();

                if (discount != null)
                {
                    var identity = ClaimsManager.GetCurrentIdentity();
                    if (identity != null && identity.UserId != null && identity.UserId != Guid.Empty)
                    {
                        User currentUser = UserManager.GetManager().GetUser(identity.UserId);
                        if (new CustomerRetriever().IsNewCustomer(currentUser))
                        {
                            if (this.addToRemovedDiscountDictionary)
                            {
                                foreach (var item in discounts)
                                {
                                    AddToDictionary(cartOrder.Id, item);
                                }
                            }
                            // Apply only the coupon code discount
                            //for new customers and remove other discounts
                            discounts.Clear();
                            discounts.Add(discount);
                        }
                        else
                        {
                            if (this.addToRemovedDiscountDictionary)
                            {
                                AddToDictionary(cartOrder.Id, discount);
                            }
                            // Remove discount if not new customer
                            discounts.Remove(discount);
                        }
                    }
                }
            }

            return discounts;
        }

        private void AddToDictionary(Guid key, CartDiscount value)
        {
            if (!removedDiscount.ContainsKey(key))
            {
                removedDiscount.Add(key, new List<CartDiscount>());
            }

            removedDiscount[key].Add(value);
        }

        private IDictionary<Guid, IList<CartDiscount>> removedDiscount;

        public IList<CartDiscount> GetNotApplicableCartDiscounts(CartOrder cartOrder, decimal subTotal, User user, List<Role> userRoles)
        {
            this.addToRemovedDiscountDictionary = true;
            this.removedDiscount = new Dictionary<Guid, IList<CartDiscount>>();
            this.GetApplicableCartDiscounts(cartOrder, subTotal, user, userRoles);
            if (removedDiscount.ContainsKey(cartOrder.Id))
            {
                var result = removedDiscount[cartOrder.Id];
                return new List<CartDiscount>(result);
            }

            return new List<CartDiscount>();
        }

        public bool addToRemovedDiscountDictionary { get; set; }
    }
}