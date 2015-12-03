using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.HtmlControls;
using System.Web.UI.WebControls;

public partial class products_Sheffield : System.Web.UI.Page
{
    [Ninject.Inject]
    public IRepository repo { get; set; }
    
    private List<PriceListView> priceListViews;

    protected void Page_Load(object sender, EventArgs e)
    {        
        priceListViews = new List<PriceListView>();
        foreach (PriceList p in repo.PriceLists)
        {
            priceListViews.Add( new PriceListView(p));
        }
    }

    public IEnumerable<SheffieldService> GetSheffieldService()
    {
        return repo.SheffieldServices;
    }

    public IEnumerable<PriceListView> GetPriceListViews(int sheffieldServiceId)
    {       
        foreach (PriceListView pv in priceListViews)
        {            
            pv.SheffieldServiceId = sheffieldServiceId;
            
        }
        return priceListViews;
    }

    public decimal GetPrice(int sheffieldServiceId, int priceListId)
    {        
        PriceList pl = repo.PriceLists.FirstOrDefault(p => p.Id == priceListId);
        SheffieldService ss = repo.SheffieldServices.FirstOrDefault(s => s.Id == sheffieldServiceId);
        Package package = new Package { Weight = ss.PackageWeight, Length = ss.PackageLength, Width = ss.PackageWidth, Height = ss.PackageHeight };
        return new PriceListView(pl).GetPackageDeliverPrice(package);
    }

    protected void ButtonAddToCart_Click(object sender, EventArgs e)
    {
        SheffieldOrder sOrder = new SheffieldOrder();

        string[] services = Request.Form["service"].Split(',');
        string[] senders = Request.Form["sender"].Split(',');
        string[] counts = Request.Form["count"].Split(',');        

        for (int i = 0; i < rpServices.Items.Count; i++)
        {
            int count = int.Parse(counts[i]);
            int sheffied_id = int.Parse(services[i]);
            SheffieldService ss = repo.SheffieldServices.FirstOrDefault(s => s.Id == sheffied_id);
            if (count != 0)
            {
                Order order = new Order();
                order.PriceListID = int.Parse(senders[i]);
                order.PriceList = repo.PriceLists.FirstOrDefault(p => p.Id == order.PriceListID);
                order.IsSheffieldOrder = true;
                order.SheffieldServiceID = sheffied_id;
                order.SheffieldService = ss;
                order.Cost = GetPrice(order.SheffieldServiceID.Value, order.PriceListID.Value) * count;
                
                Recipient r = new Recipient();
                for (int j = 0; j < count; j++)
                {
                    Package p = new Package { Weight = ss.PackageWeight, Length = ss.PackageWidth, Width = ss.PackageWidth, Height = ss.PackageHeight };
                    r.Packages.Add(p);
                }
                order.Recipients.Add(r);
                sOrder.Orders.Add(order);
            }           
        }

       
        Session.Add("SheffieldOrder", sOrder);        
        Response.Redirect("/products/SheffieldOrder.aspx");
    }
}