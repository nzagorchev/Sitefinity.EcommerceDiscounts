<%@ Control Language="C#" %>
<%@ Import Namespace="Telerik.Sitefinity.Ecommerce" %>
<%@ Import Namespace="Telerik.Sitefinity.Modules.Ecommerce" %>
<%@ Register TagPrefix="orders" Namespace="Telerik.Sitefinity.Modules.Ecommerce.Orders.Web.UI" Assembly="Telerik.Sitefinity.Ecommerce" %>

<asp:Repeater ID="discountsListView" runat="server">
    <ItemTemplate>
        <tr>
            <th>
                <div>
                    <%# HttpUtility.HtmlEncode(DataBinder.Eval(Container.DataItem, "Title")) %>:
                </div>
            </th>
            <td class="sfDiscount">
                <%# DataBinder.Eval(Container.DataItem, "SavingsAmountFormatted")%>
            </td>
        </tr>
        <orders:CouponCodeEntryListView visible="False" ID="changeCouponCodeEntryView" runat="server" IsChangeMode="True"/>
    </ItemTemplate>
</asp:Repeater>

<asp:Label ID="MessageLabel" runat="server" Text=""></asp:Label>