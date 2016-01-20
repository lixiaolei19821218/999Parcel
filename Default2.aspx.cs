using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using ServiceReferenceUKMailQA;

public partial class Default2 : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        LoginWebRequest request = new LoginWebRequest();
        request.Username = "735534185@qq.com";
        request.Password = "UKMail123";

        UKMAuthenticationServiceClient auth = new UKMAuthenticationServiceClient();
        try
        {
            UKMLoginResponse response = auth.Login(request);
            if (response.Result == UKMResultState.Successful)
            {
                message.InnerText = UKMResultState.Successful.ToString();
            }
            else if (response.Result == UKMResultState.Failed)
            {
                message.InnerText = UKMResultState.Failed.ToString();
            }
            else
            {
                message.InnerText = UKMResultState.Unknown.ToString();
            }
        }
        catch (Exception ex)
        {
            message.InnerText = ex.Message;
        }
    }
}