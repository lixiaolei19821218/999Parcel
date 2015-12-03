using System;
using System.Collections.Generic;
using System.Linq;
using System.Text.RegularExpressions;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class products_Edit : System.Web.UI.Page
{
    [Ninject.Inject]
    public IRepository repo { get; set; }

    private Order order;
    private ServiceView sv;

    protected void Page_Load(object sender, EventArgs e)
    {
        order = (Order)Session["Order"];
        if (order == null)
        {
            Response.Redirect("/");
        }

        Service service = repo.Services.FirstOrDefault(s => s.Id == order.ServiceID);
        sv = new ServiceView(service);
    }

    public IEnumerable<Recipient> GetRecipients()
    {
        return order.Recipients;
    }
  
    protected void ButtonToOrder_Click(object sender, EventArgs e)
    {
        //cache detail and value        
        Order cacheOrder = new Order();
        foreach (Recipient r in order.Recipients)
        {
            Recipient cacheRecipient = new Recipient();
            cacheRecipient.PyAddress = r.PyAddress;
            cacheRecipient.PyCity = r.PyCity;
            cacheRecipient.PyName = r.PyName;
            cacheOrder.Recipients.Add(cacheRecipient);
            foreach (Package p in r.Packages)
            {
                Package cachePackage = new Package();
                foreach (PackageItem item in p.PackageItems)
                {
                    cachePackage.PackageItems.Add(item);
                }

                cacheRecipient.Packages.Add(cachePackage);
            }
        }
        
        //addr-x-cn_name       
        var rptKeys = from k in Request.Form.AllKeys where Regex.Match(k, @"addr-\d-cn_name|addr-\d-cn_city|addr-\d-cn_street|addr-\d-postcode|addr-\d-phone").Success select k;
        var groups = rptKeys.GroupBy(k => k[5]);

        //find parcel-x-address_id
        var pkgAddIdKeys = from k in Request.Form.AllKeys where Regex.Match(k, @"parcel-\d-address_id").Success select k;

        bool pass = true;
        string errorMsg = string.Empty;

        order.Recipients.Clear();
        foreach (var g in groups)
        {
            Recipient r = new Recipient();
            order.Recipients.Add(r);

            foreach (string k in g)
            {
                if (k.Contains("cn_name"))
                {
                    r.Name = Request.Form.Get(k);
                }
                else if (k.Contains("cn_city"))
                {
                    r.City = Request.Form.Get(k);
                }
                else if (k.Contains("cn_street"))
                {
                    r.Address = Request.Form.Get(k);
                }
                else if (k.Contains("postcode"))
                {
                    r.ZipCode = Request.Form.Get(k);
                }
                else if (k.Contains("phone"))
                {
                    r.PhoneNumber = Request.Form.Get(k);
                }
            }
            
            var pkgs = from k in pkgAddIdKeys where Request.Form.Get(k) == g.Key.ToString() select k;
            foreach (var p in pkgs)
            {
                char pkgId = p[7];
                string regExp = string.Format(@"parcel-{0}-length|parcel-{0}-width|parcel-{0}-height|parcel-{0}-weight", pkgId);
                var sizeArrs = (from k in Request.Form.AllKeys where Regex.Match(k, regExp).Success select k).ToArray();

                Package package = new Package();

                for (int i = 0; i < sizeArrs.Length; i++)
                {
                    string add = sizeArrs[i];
                    if (add.Contains("weight"))
                    {
                        decimal weight;
                        if (decimal.TryParse(Request.Form.Get(add), out weight) && weight > 0m && weight < 30)
                        {
                            package.Weight = weight;
                        }
                        else
                        {
                            pass = false;
                            errorMsg = string.Format("请正确输入包裹重量", i + 1);
                            return;
                        }
                    }
                    else if (add.Contains("width"))
                    {
                        decimal width;
                        if (decimal.TryParse(Request.Form.Get(add), out width) && width > 0m)
                        {
                            package.Width = width;
                        }
                        else
                        {
                            pass = false;
                            errorMsg = string.Format("请正确输入包裹宽度", i + 1);
                            return;
                        }
                          
                    }
                    else if (add.Contains("height"))
                    {
                        decimal height;
                        if (decimal.TryParse(Request.Form.Get(add), out height) && height > 0m)
                        {
                            package.Height = height;
                        }
                        else
                        {
                            pass = false;
                            errorMsg = string.Format("请正确输入包裹高度", i + 1);
                            return;
                        }
                          
                    }
                    else if (add.Contains("length"))
                    {
                        decimal length;
                        if (decimal.TryParse(Request.Form.Get(add), out length) && length > 0m)
                        {
                            package.Length = length;
                        }
                        else
                        {
                            pass = false;
                            errorMsg = string.Format("请正确输入包裹长度", i + 1);
                            return;
                        }
                          
                    }
                }

                r.Packages.Add(package);
            }            
        }

        //restore detail and value
        int rCount = order.Recipients.Count < cacheOrder.Recipients.Count ? order.Recipients.Count : cacheOrder.Recipients.Count;
        for (int i = 0; i < rCount; i++)
        {
            Recipient r = order.Recipients.ElementAt(i);
            Recipient cacheR = cacheOrder.Recipients.ElementAt(i);
            r.PyName = cacheR.PyName;
            r.PyCity = cacheR.PyCity;
            r.PyAddress = cacheR.PyAddress;
            int pCount = r.Packages.Count < cacheR.Packages.Count ? r.Packages.Count : cacheR.Packages.Count; 
            for (int j = 0; j < pCount; j++)
            {
                order.Recipients.ElementAt(i).Packages.ElementAt(j).PackageItems = cacheOrder.Recipients.ElementAt(i).Packages.ElementAt(j).PackageItems;                
            }
        }

        if (pass)
        {
            Response.Redirect("product.aspx");
        }
        else
        {
            LabelError.Visible = true;
            LabelError.Text = errorMsg;
        }
    }
}