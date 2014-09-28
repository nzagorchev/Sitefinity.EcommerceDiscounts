using System.Collections.Generic;
using Telerik.Sitefinity.Ecommerce.Orders.Model;
using Telerik.Sitefinity.Modules.Ecommerce;
using Telerik.Sitefinity.Modules.Ecommerce.Configuration;
using Telerik.Sitefinity.Modules.Ecommerce.Orders.Business;
using Telerik.Sitefinity.Security.Model;

namespace SitefinityWebApp.Discounts
{
    public class EcommerceOrderCalculatorCustom : EcommerceOrderCalculator
    {
        public EcommerceOrderCalculatorCustom()
        {
        }

        protected override decimal GetWithoutShippingTax(CartOrder cartOrder, User user, List<Role> userRoles, bool useExchangeRate)
        {
            decimal taxOnTotalBasePrice = GetPreDiscountTax(cartOrder, useExchangeRate);
            decimal totalBasePrice = GetSubTotalWithoutTaxes(cartOrder, useExchangeRate);

            decimal totalBasePriceNoExchangeRate = GetTotalBasePriceNoExchangeRate(cartOrder);

            decimal discountTotal = new DiscountCalculatorCustom().CalculateAndApplyOrderDiscounts(cartOrder, totalBasePriceNoExchangeRate, user, userRoles, useExchangeRate);

            decimal withoutShippingTax = 0;
            var taxDisplayMode = EcommerceSettings.Taxes.TaxDisplayMode;
            if (taxDisplayMode == EcommerceConstants.OrdersConstants.ExcludingTax)
            {
                withoutShippingTax = EcommerceOrderCalculatorCustom.TaxIncludingDiscount(taxOnTotalBasePrice, totalBasePrice, discountTotal);
            }
            else
            {
                withoutShippingTax = taxOnTotalBasePrice;
            }

            return withoutShippingTax;
        }

        private static decimal TaxIncludingDiscount(decimal taxOnTotalBasePrice, decimal totalBeforeDiscounts, decimal discountAmount)
        {
            return totalBeforeDiscounts == 0m ? taxOnTotalBasePrice :
                taxOnTotalBasePrice * (totalBeforeDiscounts - discountAmount) / totalBeforeDiscounts;
        }

        protected override decimal GetDiscountTotal(CartOrder cartOrder, User user, List<Role> userRoles, bool useExchangeRate)
        {
            decimal totalBasePriceNoExchangeRate = GetTotalBasePriceNoExchangeRate(cartOrder);
            decimal exchangeRateSubTotal = GetSubTotalTaxInclusive(cartOrder, useExchangeRate);
            decimal sumRoundedOrderDiscounts = new DiscountCalculatorCustom().SumRoundedOrderDiscounts(cartOrder, exchangeRateSubTotal, totalBasePriceNoExchangeRate, user, userRoles, useExchangeRate);
            return sumRoundedOrderDiscounts;
        }
    }
}