<%@ Control Language="C#" %>
<%@ Register Assembly="Telerik.Web.UI" Namespace="Telerik.Web.UI" TagPrefix="telerik" %>
<%@ Register Assembly="Telerik.Sitefinity.Ecommerce" Namespace="Telerik.Sitefinity.Modules.Ecommerce.Catalog.Web.UI.Fields" TagPrefix="sfCatalog" %>
<%@ Register TagPrefix="sf" Namespace="Telerik.Sitefinity.Web.UI" Assembly="Telerik.Sitefinity" %>
<%@ Register TagPrefix="orders" Namespace="Telerik.Sitefinity.Modules.Ecommerce.Orders.Web.UI" Assembly="Telerik.Sitefinity.Ecommerce" %>
<%@ OutputCache Duration="1" VaryByParam="*" %>
<%@ Import Namespace="Telerik.Sitefinity.Ecommerce" %>
<%@ Import Namespace="Telerik.Sitefinity.Modules.Ecommerce" %> 
  
  <%@ Register TagPrefix="cs" Namespace="SitefinityWebApp.Discounts" Assembly="SitefinityWebApp" %>


<div class="sfshoppingCartWrp">
    <!-- This container is used to display warning messages about set up of the widget;
         when control is set correctly, this container is invisible -->
    <div id="widgetStatus" runat="server" visible="false" class="sfshoppingCartStatus">
        <asp:Label ID="widgetStatusMessage" runat="server" />
    </div>

    <asp:PlaceHolder id="widgetBody" runat="server">
        <h1 class="sfshoppingCartTitle" id="widgetHeading" runat="server">
            <asp:Literal ID="Literal1" runat="server" Text='<%$Resources:OrdersResources, ShoppingCart %>' />
        </h1>

        <sf:Message runat="server" ID="cartUpdateMessage" />

        <asp:PlaceHolder runat="server" ID="itemsCountPlaceholder">
        <div class="sfProductsInCart">
            <asp:Literal ID="productsCountLabel" runat="server" />&nbsp;<asp:Literal runat="server" Text='<%$Resources:OrdersResources, items %>' />
        </div>
        </asp:PlaceHolder>

        <telerik:RadGrid id="shoppingCartGrid" runat="server" Skin="Basic" ShowFooter="False" EnableEmbeddedBaseStylesheet="false" EnableEmbeddedSkins="false">
            <MasterTableView AutoGenerateColumns="false" DataKeyNames="Id">
                <Columns>
                    <telerik:GridTemplateColumn HeaderText='' UniqueName="ProductImage" ItemStyle-CssClass="sfItmTmbCol" HeaderStyle-CssClass="sfItmTmbCol">
                        <ItemTemplate>
                            <div class="sfproductTmbWrp">
                                <asp:Image runat="server" ID="productThumbnailImage" CssClass="sfproductTmb" />
                            </div>
                        </ItemTemplate>
                    </telerik:GridTemplateColumn>

                    <telerik:GridTemplateColumn HeaderText='<%$Resources:OrdersResources, ProductDescription %>' UniqueName="ProductDescription" ItemStyle-CssClass="sfItmTitleCol" HeaderStyle-CssClass="sfItmTitleCol">
                        <ItemTemplate>
                            <div class="sfItmTitleWrp">
                                <asp:HyperLink ID="productTitleLink" runat="server" Text='<%# Eval("Title") %>' CssClass="sfItmTitle" />
                            </div>
                            <asp:Label ID="OutOfStock" CssClass="sfItemOutOfStockMessage" Text="<%$Resources:OrdersResources, OutOfStock %>" Visible="false" runat="server" />
                            <asp:Label ID="InventoryChange" CssClass="sfItmTitleInventoryChangeCol" Text="<%$Resources:OrdersResources, InventoryChange %>" Visible="false" runat="server" />
                            <div class="sfItmLnksWrp">
                                <asp:LinkButton ID="removeButton" runat="server" Text='<%$Resources:OrdersResources, Remove %>' CommandName="remove" CssClass="sfItmRemove" />
                                <asp:LinkButton ID="moveToWishlistButton" runat="server" Text='<%$Resources:OrdersResources, MoveToWishlist %>' CommandName="moveToWishlist" CssClass="sfToWishList" />
                            </div>
                        </ItemTemplate>   
                    </telerik:GridTemplateColumn>

                    <telerik:GridTemplateColumn  UniqueName="Options" ItemStyle-CssClass="sfItmOptionsCol" HeaderStyle-CssClass="sfItmOptionsCol">
                        <ItemTemplate>
                            <div>
                                <%# Eval("Options")%>
                            </div>
                        </ItemTemplate>
                    </telerik:GridTemplateColumn> 

                    <telerik:GridTemplateColumn UniqueName="Description" ItemStyle-CssClass="sfItmDiscountDscCol"  HeaderStyle-CssClass="sfItmDiscountDscCol">
                        <ItemTemplate>
                            <div>
                                 <%# Eval("Description")%>
                            </div>
                        </ItemTemplate>
                    </telerik:GridTemplateColumn>

                    <telerik:GridTemplateColumn UniqueName="BasePrice" 
                        ItemStyle-CssClass="sfSingleItmPriceCol" HeaderStyle-CssClass="sfSingleItmPriceCol">
                        <ItemTemplate>
                            <sfCatalog:DisplayPriceField id="displayPriceField" ObjectType="Cart" ObjectId='<%# Eval("Id") %>' runat="server" />
                        </ItemTemplate>
                    </telerik:GridTemplateColumn>   

                    <telerik:GridTemplateColumn UniqueName="ProductQuantity" HeaderText="<%$Resources:OrdersResources, Quantity %>" ItemStyle-CssClass="sfItmQuantityCol" HeaderStyle-CssClass="sfItmQuantityCol">
                        <ItemTemplate>
                                <span>x</span>
                                <asp:HiddenField ID="cartDetailId" runat="server" />
                                <asp:TextBox ID="quantity" runat="server" Text='<%# Eval("Quantity") %>' CssClass="sfTxt" />
                                <asp:RangeValidator ID="quantityValidator" runat="server"
                                    MinimumValue="0"
                                    MaximumValue="9999"
                                    ControlToValidate="quantity"
                                    Type="Integer"
                                    Display="Dynamic" 
                                    CssClass="sfErrorWrp">
                                    <span class="sfError">
                                        <asp:Literal runat="server" Text="<%$Resources: OrdersResources, ProductQuantityIsInvalidInShoppingCart %>" />
                                    </span>
                                </asp:RangeValidator>
                        </ItemTemplate>
                    </telerik:GridTemplateColumn>

                    <telerik:GridTemplateColumn UniqueName="NewPrice" 
                        HeaderText='<%$Resources:OrdersResources, Price %>' 
                         ItemStyle-CssClass="sfItmPriceCol" FooterStyle-CssClass="sfItmPriceCol" 
                                            HeaderStyle-CssClass="sfItmPriceCol" 
                        >
                        <ItemTemplate>
                            <asp:Label ID="newPriceLabel" runat="server" Text='<%# Eval("DisplayTotalFormatted") %>' CssClass="sfTxtLbl" />
                        </ItemTemplate>
                    </telerik:GridTemplateColumn>
                </Columns>           
            </MasterTableView>
        </telerik:RadGrid>

        <asp:Panel ID="shoppingCartGridFooter" runat="server" CssClass="sfShoppingCartGridFooter sfClearfix">
            <asp:UpdatePanel runat="server" UpdateMode="Conditional" ID="outerCouponCodeUpdatePanel">
                <ContentTemplate>
                    <div class="sfShoppingCartCouponEntryField">
                        <orders:CouponCodeEntryView ID="couponCodeEntryView" runat="server" IsChangeMode="False"/>
                    </div>
                </ContentTemplate>
            </asp:UpdatePanel>

                <asp:UpdatePanel runat="server">
                    <ContentTemplate>
                        <div class="sfShoppingCartTotal">
                            <table class="sfShoppingCartDiscountList">
                                <tbody>
                                    <tr runat="server" ID="beforeDiscountRow">
                                        <th>
                                            <asp:Label ID="productTotalQuantityBeforeDiscountLabel" runat="server" />
                                            <asp:Label runat="server" Text="<%$ Resources:OrdersResources, Subtotal %>" CssClass="sfTxtLbl"/>:
                                        </th>
                                        <td>
                                            <asp:Label ID="totalPrice" runat="server" Text="" CssClass="sfTxtLbl" />
                                        </td>
                                    </tr>
                                    <cs:MyDiscountList runat="server" ID="discountRows"/>
                                </tbody>
                            </table>
                        </div>
                        <div class="sfTotalRowWrp">
                            <asp:Label ID="productTotalQuantity" runat="server" />
                            <asp:Label ID="subTotalLabel" runat="server" Text='<%$Resources:OrdersResources, SubtotalWithDiscounts %>' CssClass="sfTxtLbl" />:&nbsp;
                            <strong class="sfPriceTotal"><asp:Label ID="afterDiscountPrice" runat="server" Text="" CssClass="sfTxtLbl" /></strong>
                        </div>
                    </ContentTemplate>
                </asp:UpdatePanel>
                <asp:LinkButton id="updateButton" Text="<%$Resources:OrdersResources, Update %>" runat="server" CssClass="sfshoppingCartUpdateLnk" />
                
        </asp:Panel>

        <asp:Panel ID="noProductsInShoppingCartPanel" runat="server" Visible="false" CssClass="sfNoProductsInCartMsg">
            <asp:Literal runat="server" Text='<%$Resources:OrdersResources, NoProductsInShoppingCart %>' />
        </asp:Panel>

        <div class="sfshoppingCartBtnsWrp sfClearfix">
            <asp:HyperLink ID="continueShoppingLink" runat="server" Text='<%$Resources:OrdersResources, ContinueShopping %>' NavigateUrl="#" CssClass="sfBackBtn" />
            <div id="checkoutButtonDiv" runat="server">
                <asp:Button ID="checkoutButton" runat="server" Text='<%$Resources:OrdersResources, Checkout %>' CssClass="sfCheckoutBtn" />
            </div>
        </div>
    </asp:PlaceHolder>
</div>
