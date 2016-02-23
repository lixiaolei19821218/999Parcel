using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using ServiceReferenceUKMailQA;
using UKMCollectionService;
using UKMConsignmentService;
using System.IO;

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
        /*
        AddDomesticConsignmentWebRequest consignmentRequest = new AddDomesticConsignmentWebRequest();
        consignmentRequest.Username = "735534185@qq.com";
        consignmentRequest.AuthenticationToken = loginResponse.AuthenticationToken;
        consignmentRequest.CollectionJobNumber = colloctionResponse.CollectionJobNumber;
        consignmentRequest.AccountNumber = "S900118";
        consignmentRequest.ContactName = "Mer";
        consignmentRequest.BusinessName = "999Parcel LTD";
        consignmentRequest.Address = new AddressWebModel() 
        {
            Address1 = "Address1",
            Address2 = "Address2",
            Address3 = "Address3", 
            CountryCode = "GBR", 
            County = "West Midlands", 
            PostalTown = "Birmingham", 
            Postcode = "B8 2SQ" 
        };
        consignmentRequest.Email = "735534185@qq.com";
        consignmentRequest.Telephone = "123";
        consignmentRequest.PreDeliveryNotification = PreDeliveryNotificationType.Email;
        //consignmentRequest.CustomersRef =
        //consignmentRequest.AlternativeRef = 
        consignmentRequest.Items = 3;
        consignmentRequest.Weight = 10;
        consignmentRequest.ServiceKey = 220;
        consignmentRequest.SpecialInstructions1 = "SpecialInstructions1";
        consignmentRequest.SpecialInstructions2 = "SpecialInstructions2";
        consignmentRequest.ConfirmationOfDelivery = true;
        consignmentRequest.ConfirmationEmail = "735534185@qq.com";
        //consignmentRequest.ConfirmationTelephone = "123";
        consignmentRequest.ExchangeOnDelivery = false;
        consignmentRequest.ExtendedCover = 0;
        consignmentRequest.SignatureOptional = true;
        //consignmentRequest.SecureLocation1 = 
        //consignmentRequest.SecureLocation2 = 
        consignmentRequest.BookIn = false;
        //consignmentRequest.CODAmount = 
        consignmentRequest.LongLength = false;
        UKMAddDomesticConsignmentWebResponse consignmentResponse = consignmentService.AddDomesticConsignment(consignmentRequest);        
        message.InnerText = consignmentResponse.Result.ToString();   
        for (int i = 0; i < consignmentResponse.Labels.Length; i++)
        {
            string png = AppDomain.CurrentDomain.BaseDirectory + "UK_Mail\\" + i + ".png";
            Byte[] byt = consignmentResponse.Labels[i];
            File.WriteAllBytes(png, byt);
        }  
        */

        /*
        UKMConsignmentService.AddPacketConsignmentWebRequest addParcelRequest = new AddPacketConsignmentWebRequest();
        addParcelRequest.AuthenticationToken = loginResponse.AuthenticationToken;
        addParcelRequest.Username = "735534185@qq.com";
        addParcelRequest.AccountNumber = "S900118";
        addParcelRequest.CollectionJobNumber = colloctionResponse.CollectionJobNumber;
        addParcelRequest.ContactName = "Mer Tang";
        addParcelRequest.BusinessName = "999Parcel LTD";
        addParcelRequest.Address = new PacketAddressWebModel()
        {
            Address1 = "Address1",
            Address2 = "Address2",
            Address3 = "Address3",            
            County = "West Midlands",
            PostalTown = "Birmingham",
            Postcode = "B8 2SQ" 
        };
        addParcelRequest.WeightInGrams = 10;
        addParcelRequest.PacketLength = 20;
        addParcelRequest.PacketWidth = 30;
        addParcelRequest.PacketHeight = 50;
        addParcelRequest.DeliveryMessage1 = "DeliveryMessage1";
        addParcelRequest.DeliveryMessage2 = "DeliveryMessage2";
        UKMAddPacketConsignmentWebResponse parcelResponse = consignmentService.AddPacketConsignment(addParcelRequest);
        
        if (parcelResponse.Result == UKMConsignmentService.UKMResultState.Successful)
        {
            message.InnerText = parcelResponse.ConsignmentNumber;
            for (int i = 0; i < parcelResponse.Labels.Length; i++)
            {
                string png = AppDomain.CurrentDomain.BaseDirectory + "UK_Mail\\parcel_" + i + ".png";
                Byte[] byt = parcelResponse.Labels[i];
                File.WriteAllBytes(png, byt);
            }  
        }
        else if (parcelResponse.Result == UKMConsignmentService.UKMResultState.Failed)
        {
            foreach (UKMConsignmentService.UKMWebError error in parcelResponse.Errors)
            {
                message.InnerText += error.Description + "\n\r";
            }
        }
        else
        {
            message.InnerText = parcelResponse.Result.ToString();
        }
         * */
        /*
        AddSendToThirdPartyWebRequest send2ThirdPartReq = new AddSendToThirdPartyWebRequest();
        send2ThirdPartReq.Username = "735534185@qq.com";
        send2ThirdPartReq.AuthenticationToken = loginResponse.AuthenticationToken;
        send2ThirdPartReq.AccountNumber = "S900118";
        send2ThirdPartReq.CollectionDate = DateTime.Today.AddDays(1);
        send2ThirdPartReq.CollectionContactName = "Amy Long";
        //send2ThirdPartReq.CollectionBusinessName
        send2ThirdPartReq.CollectionAddress = new AddressWebModel()
        {
            Address1 = "CollectionAddress1",
            Address2 = "CollectionAddress2",
            Address3 = "CollectionAddress3",
            CountryCode = "GBR",
            County = "Berkshire",
            PostalTown = "Slough",
            Postcode = "SL1 4PL" 
        };
        send2ThirdPartReq.CollectionEmail = "735534185@qq.com";
        send2ThirdPartReq.CollectionTelephone = "123";
        send2ThirdPartReq.ServiceKey = 451;
        send2ThirdPartReq.CollectionSpecialInstructions1 = "CollectionSpecialInstructions1";
        send2ThirdPartReq.CollectionSpecialInstructions2 = "CollectionSpecialInstructions2";
        send2ThirdPartReq.DescriptionOfGoods1 = "DescriptionOfGoods1";
        send2ThirdPartReq.DescriptionOfGoods2 = "DescriptionOfGoods2";
        send2ThirdPartReq.CollectionTimeReady = send2ThirdPartReq.CollectionDate.AddHours(12);
        send2ThirdPartReq.CollectionOpenLunchtime = true;
        send2ThirdPartReq.CollectionLatestPickup = send2ThirdPartReq.CollectionTimeReady.AddHours(5);
        send2ThirdPartReq.BookIn = false;
        send2ThirdPartReq.DeliveryContactName = "Mel Tang";
        send2ThirdPartReq.DeliveryBusinessName = "999Parcel LTD";
        send2ThirdPartReq.DeliveryAddress = new AddressWebModel()
        {
            Address1 = "DeliveryAddress1",
            Address2 = "DeliveryAddress2",
            Address3 = "DeliveryAddress3",
            CountryCode = "GBR",
            County = "West Midlands",
            PostalTown = "Birmingham",
            Postcode = "B8 2SQ" 
        };
        send2ThirdPartReq.DeliveryEmail = "735534185@qq.com";
        send2ThirdPartReq.DeliverySpecialInstructions1 = "DeliverySpecialInstructions1";
        send2ThirdPartReq.DeliverySpecialInstructions2 = "DeliverySpecialInstructions2";
        UKMAddSendToThirdPartyWebResponse add2ThirdPartyResponse = consignmentService.AddSendToThirdParty(send2ThirdPartReq);
        if (add2ThirdPartyResponse.Result == UKMConsignmentService.UKMResultState.Successful)
        {
            message.InnerText = add2ThirdPartyResponse.ConsignmentNumber;
        }
        else if (add2ThirdPartyResponse.Result == UKMConsignmentService.UKMResultState.Failed)
        {
            foreach (UKMConsignmentService.UKMWebError error in add2ThirdPartyResponse.Errors)
            {
                message.InnerText += error.Description + "\r\n";
            }
        }
        else
        {
            message.InnerText = add2ThirdPartyResponse.Result.ToString();
        }
         * */

        AddReturnWebRequest returnReq = new AddReturnWebRequest();
        returnReq.Username = "735534185@qq.com";
        returnReq.AuthenticationToken = loginResponse.AuthenticationToken;
        returnReq.AccountNumber = "S900118";
        returnReq.CollectionDate = DateTime.Today.AddDays(1);
        returnReq.CollectionContactName = "Amy Long";
        returnReq.CollectionBusinessName = "Delcam Ltd";
        returnReq.CollectionAddress = new AddressWebModel()
        {
            Address1 = "CollectionAddress1",
            Address2 = "CollectionAddress2",
            Address3 = "CollectionAddress3",
            CountryCode = "GBR",
            County = "Berkshire",
            PostalTown = "Slough",
            Postcode = "SL1 4PL"
        };
        returnReq.CollectionEmail = "735534185@qq.com";
        returnReq.CollectionTelephone = "123";        
        //returnReq.CollectionCustomersRef = "";
        returnReq.ServiceKey = 401;
        returnReq.CollectionSpecialInstructions1 = "Please call me or text.";
        //returnReq.CollectionSpecialInstructions2 = "CollectionSpecialInstructions2";
        returnReq.DeliverySpecialInstructions1 = "DeliverySpecialInstructions1";
        returnReq.DeliverySpecialInstructions2 = "DeliverySpecialInstructions2";
        returnReq.DescriptionOfGoods1 = "DescriptionOfGoods1";
        returnReq.DescriptionOfGoods2 = "DescriptionOfGoods2";
        returnReq.CollectionTimeReady = returnReq.CollectionDate.AddHours(12);
        returnReq.CollectionOpenLunchtime = false;
        returnReq.CollectionLatestPickup = returnReq.CollectionTimeReady.AddHours(3);
        returnReq.BookIn = false;
        UKMAddReturnToSenderWebResponse returnResponse = consignmentService.AddReturnToSender(returnReq);
        if (returnResponse.Result == UKMConsignmentService.UKMResultState.Successful)
        {
            message.InnerText = returnResponse.ConsignmentNumber;
        }
        else if (returnResponse.Result == UKMConsignmentService.UKMResultState.Failed)
        {
            foreach (UKMConsignmentService.UKMWebError error in returnResponse.Errors)
            {
                message.InnerText += error.Description + "\r\n";
            }
        }
        else
        {
            message.InnerText = returnResponse.Result.ToString();
        }
    }
}