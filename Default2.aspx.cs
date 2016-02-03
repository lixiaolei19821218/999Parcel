using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using ServiceReferenceUKMailQA;
using UKMCollectionService;
using UKMConsignmentService;

public partial class Default2 : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        LoginWebRequest loginRequest = new LoginWebRequest();
        loginRequest.Username = "735534185@qq.com";
        loginRequest.Password = "UKMail123";
        UKMLoginResponse loginResponse = null;
        UKMAuthenticationServiceClient auth = new UKMAuthenticationServiceClient();
        try
        {
            loginResponse = auth.Login(loginRequest);
            message.InnerText = loginResponse.Result.ToString();      
        }
        catch (Exception ex)
        {
            message.InnerText = ex.Message;
        }
        UKMCollectionServiceClient collectionService = new UKMCollectionServiceClient();
        AddCollectionWebRequest collectionRequest = new AddCollectionWebRequest();
        collectionRequest.AccountNumber = "S900118";
        collectionRequest.AuthenticationToken = loginResponse.AuthenticationToken;
        collectionRequest.ClosedForLunch = false;
        collectionRequest.EarliestTime = DateTime.Today.AddDays(2).AddHours(11);
        collectionRequest.LatestTime = DateTime.Today.AddDays(2).AddHours(17);
        collectionRequest.RequestedCollectionDate = DateTime.Today.AddDays(2).AddHours(17);
        collectionRequest.SpecialInstructions = "Test";
        collectionRequest.Username = "735534185@qq.com";

        UKMAddCollectionWebResponse colloctionResponse = null;
        try
        {
            colloctionResponse = collectionService.BookCollection(collectionRequest);
            foreach (UKMCollectionService.UKMWebError error in colloctionResponse.Errors)
            {
                message.InnerText += error.Description + "\n\r";
            }
            message.InnerText = colloctionResponse.CollectionJobNumber;            
        }
        catch (Exception ex)
        {
            message.InnerText = ex.Message;
        }
        UKMConsignmentServiceClient consignmentService = new UKMConsignmentServiceClient();
        AddDomesticConsignmentWebRequest consignmentRequest = new AddDomesticConsignmentWebRequest();
        consignmentRequest.AccountNumber = "S900118";
        consignmentRequest.AuthenticationToken = loginResponse.AuthenticationToken;
        
        consignmentRequest.Address = new AddressWebModel() { Address1 = "" };
        UKMAddDomesticConsignmentWebResponse consignmentResponse = consignmentService.AddDomesticConsignment(consignmentRequest);
        //consignmentResponse.
    }
}