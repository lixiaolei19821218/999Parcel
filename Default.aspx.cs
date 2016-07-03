using System;
using System.Collections.Generic;
using System.Linq;
using System.Text.RegularExpressions;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Default : System.Web.UI.Page
{
    //[Ninject.Inject]
    //public IRepository repo { get; set; }

    private Order order = new Order();

    public Order Order
    {
        get
        {
            return order;
        }
    }

    protected void Page_Load(object sender, EventArgs e)
    {
        if (Request.Form["btnQuery"] != null)
        {
            string number = Request.Form["txtTraceNumber"];
            Response.Redirect(string.Format("/Trace/Default.aspx?txtTraceNumber={0}", number));
        }
    }

    protected void btnSubmit_Click(object sender, EventArgs e)
    {
        //pkgAttr is like addr_x-x-weight
        var pkgAttrs = from p in Request.Form.AllKeys where Regex.Match(p, @"addr_\d-\d-weight|addr_\d-\d-length|addr_\d-\d-width|addr_\d-\d-height").Success select p;
        var groups = from p in pkgAttrs group p by p[5];

        foreach (var g in groups)
        {
            Recipient r = new Recipient();
            order.Recipients.Add(r);

            var pkgs = from p in g group p by p[7];
            foreach (var pkg in pkgs)
            {
                Package package = new Package();
                package.PackageItems.Add(new PackageItem() { Description = "Baby Milk Powder" });
                r.Packages.Add(package);

                decimal weight, length, width, height;
                weight = length = width = height = 0m;
                foreach (string pkgAttr in pkg)
                {
                    if (pkgAttr.Contains("weight"))
                    {
                        if (decimal.TryParse(Request.Form.Get(pkgAttr), out weight) && weight > 0m && weight < 30)
                        {
                            package.Weight = weight;
                        }
                        else
                        {
                            LabelError.Text = "请正确输入重量";
                            LabelError.Visible = true;
                            return;
                        }
                    }
                    else if (pkgAttr.Contains("length"))
                    {
                        if (decimal.TryParse(Request.Form.Get(pkgAttr), out length) && length > 0m && length < 105m)
                        {
                            package.Length = length;
                        }
                        else
                        {
                            LabelError.Text = "请正确输入长度";
                            LabelError.Visible = true;
                            return;
                        }
                    }
                    else if (pkgAttr.Contains("width"))
                    {
                        if (decimal.TryParse(Request.Form.Get(pkgAttr), out width) && width > 0m && width < 105m)
                        {
                            package.Width = width;
                        }
                        else
                        {
                            LabelError.Text = "请正确输入宽度";
                            LabelError.Visible = true;
                            return;
                        }
                    }
                    else if (pkgAttr.Contains("height"))
                    {
                        if (decimal.TryParse(Request.Form.Get(pkgAttr), out height) && height > 0m && height < 105m)
                        {
                            package.Height = height;
                        }
                        else
                        {
                            LabelError.Text = "请正确输入高度";
                            LabelError.Visible = true;
                            return;
                        }
                    }

                    if (length * width * height / 5000m > 30m)
                    {
                        LabelError.Text = "有包裹的体积重量(长×宽×高÷5000)不能大于30";
                        LabelError.Visible = true;
                        return;
                    }
                }
            }
        }

        Session.Add("Order", order);
        Response.Redirect("/products/");
    }

    protected string GetGreeting()
    {
        return "";
    }

    protected DateTime GetLastLoginTime()
    {
        return DateTime.Now;
    }

    

    public IEnumerable<News> GetNews()
    {        
        UK_ExpressEntities entities = new UK_ExpressEntities();
        return entities.News.ToList().Take(5);
    }
}