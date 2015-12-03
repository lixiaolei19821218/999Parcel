using iTextSharp.text;
using iTextSharp.text.pdf;
using System;
using System.Collections.Generic;
using System.Configuration;
using System.Drawing;
using System.IO;
using System.Linq;
using System.Web;
using System.Web.Profile;
using ZXing;
using ZXing.Common;

/// <summary>
/// Bpost 的摘要说明
/// </summary>
public class Bpost
{
    public static string GenerateLciFile(string contact, Order o, HttpApplicationState application, IRepository repo)
    {
        string senderId, contactNumber, subContactNumber;
        ParseContact(contact, out senderId, out contactNumber, out subContactNumber);
        string sequenceId = o.Id.ToString().PadLeft(5, '0');

        string dir = AppDomain.CurrentDomain.BaseDirectory + "bpost_files/" + o.User + "/";
        if (!Directory.Exists(dir))
        {
            Directory.CreateDirectory(dir);
        }
        string file = dir + senderId + "_" + sequenceId + ".txt";
        StreamWriter sw = new StreamWriter(file);
        string header = string.Format("*BPI_IN*            {0}*V 3.1 *{1}", senderId, sequenceId);
        sw.WriteLine(header);

        int lineCount = 0;
        foreach (Recipient r in o.Recipients)
        {
            foreach (Package p in r.Packages)
            {
                string barcode = GenerateBarcode(contactNumber, subContactNumber, p.Id.ToString());

                string addresseePlace, addresseeStreet;
                if (p.Recipient.PyAddress.Length <= 40)
                {
                    addresseePlace = string.Empty.PadLeft(40);
                    addresseeStreet = p.Recipient.PyAddress.PadLeft(40);
                }
                else if (p.Recipient.PyAddress.Length <= 80)
                {
                    addresseePlace = p.Recipient.PyAddress.Substring(0, 40);
                    addresseeStreet = p.Recipient.PyAddress.Substring(40).PadLeft(40);
                }
                else
                {
                    addresseePlace = p.Recipient.PyAddress.Substring(0, 40);
                    addresseeStreet = p.Recipient.PyAddress.Substring(40, 40);
                }

                string senderPlace, senderStreet;
                string tempAddress = p.Recipient.Order.SenderAddress1 + p.Recipient.Order.SenderAddress2 + p.Recipient.Order.SenderAddress3;
                if (tempAddress.Length <= 40)
                {
                    senderPlace = string.Empty.PadLeft(40);
                    senderStreet = tempAddress.PadLeft(40);
                }
                else if (tempAddress.Length <= 80)
                {
                    senderPlace = tempAddress.Substring(0, 40);
                    senderStreet = tempAddress.Substring(40).PadLeft(40);
                }
                else
                {
                    senderPlace = tempAddress.Substring(0, 40);
                    senderStreet = tempAddress.Substring(40, 40);
                }

                string a01 = string.Format("{0}{1}{2}{3}{4}{5}{6}{7}{8}{9}{10}{11}{12}{13}{14}{15}{16}{17}{18}{19}{20}{21}{22}{23}{24}{25}{26}{27}{28}{29}{30}{31}{32}",
                    "A01",
                    "01",
                    barcode,
                    senderId,
                    "139",
                    p.Recipient.Order.SenderName.PadLeft(40),//
                    string.Empty.PadLeft(40),//Sender – Department
                    p.Recipient.Order.SenderName.PadLeft(40),//Sender – Contact name
                    senderPlace,//Sender – Place
                    senderStreet,
                    string.Empty.PadLeft(8),//Sender – House number
                    string.Empty.PadLeft(8),//Sender – Box number
                    p.Recipient.Order.SenderZipCode.PadLeft(8),//Sender – Zip code
                    p.Recipient.Order.SenderCity.PadLeft(40),
                    " GB",
                    p.Recipient.Order.SenderPhone.PadLeft(20),
                    string.Empty.PadLeft(50),//Sender – E-mail
                    string.Empty.PadLeft(20),//Sender – Mobile
                    p.Recipient.PyName.PadLeft(40),
                    string.Empty.PadLeft(40),//Addressee – Department
                    p.Recipient.PyName.PadLeft(40),
                    addresseePlace,//Addressee – Place
                    addresseeStreet,
                    string.Empty.PadLeft(8),//Addressee – House number
                    string.Empty.PadLeft(8),//Addressee – Box number
                    p.Recipient.ZipCode.PadLeft(8),
                    p.Recipient.PyCity.PadLeft(40),
                    " CN",
                    p.Recipient.PhoneNumber.PadLeft(20),
                    string.Empty.PadLeft(50),//Addressee – E-mail
                    p.Recipient.PhoneNumber.PadLeft(20),//Addressee – Mobile
                    ((int)(p.Weight * 1000)).ToString().PadLeft(7, '0'),//Weight
                    (3 + 7 * p.PackageItems.Count).ToString().PadLeft(3, '0')
                    );

                application.Lock();   
                ProfileBase profile = ProfileBase.Create("EASequenceNumber");
                int sequenceNumber = (int)(profile["counter"]);
                profile["counter"] = ++sequenceNumber;
                profile.Save();
                application.UnLock();

                /*
                application.Lock();                
                int sequenceNumber = application["SequenceNumber"] != null ? (int)application["SequenceNumber"] : int.Parse(ConfigurationManager.AppSettings["EAStartNum"]);
                application["SequenceNumber"] = sequenceNumber + 1;
                application.UnLock();              
                */

                int sum = 0;
                int[] weightFactors = new int[] { 8, 6, 4, 2, 3, 5, 9, 7 };
                string digits = sequenceNumber.ToString();
                for (int i = 0; i < 8; i++)
                {
                    sum += int.Parse(digits[i].ToString()) * weightFactors[i];
                }
                int remainder = sum % 11;
                int checkSum;
                if (remainder == 0)
                {
                    checkSum = 5;
                }
                else if (remainder == 1)
                {
                    checkSum = 0;
                }
                else
                {
                    checkSum = 11 - remainder;
                }
                string emsBarcode = string.Format("EA{0}{1}BE", sequenceNumber, checkSum);
                p.TrackNumber = emsBarcode;
                string d01_0 = string.Format("D01461{0}", emsBarcode);
                string d01_1 = string.Format("D01900GOODS");
                string d01_2 = string.Format("D01901RTS");

                sw.WriteLine(a01);
                sw.WriteLine(d01_0);
                sw.WriteLine(d01_1);
                sw.WriteLine(d01_2);
                lineCount += 4;

                for (int i = 0; i < p.PackageItems.Count; i++)
                {
                    string number = (i + 1).ToString().PadLeft(3, '0');
                    PackageItem item = p.PackageItems.ElementAt(i);
                    string d02_0 = string.Format("D02960{0}{1}", number, item.Count.Value.ToString().PadLeft(6, '0'));
                    string d02_1 = string.Format("D02961{0}{1}", number, item.Value.Value.ToString("F2").PadLeft(12, '0').Replace('.', ','));
                    string d02_2 = string.Format("D02962{0}GBP", number);
                    string d02_3 = string.Format("D02963{0}{1}", number, item.Description);
                    string d02_4 = string.Format("D02964{0}{1}", number, ((int)(item.NettoWeight * 1000)).ToString().PadLeft(4, '0'));
                    string d02_5 = string.Format("D02965{0}999999", number);
                    string d02_6 = string.Format("D02966{0}GB", number);             
                    
                    sw.WriteLine(d02_0);
                    sw.WriteLine(d02_1);
                    sw.WriteLine(d02_2);
                    sw.WriteLine(d02_3);
                    sw.WriteLine(d02_4);
                    sw.WriteLine(d02_5);
                    sw.WriteLine(d02_6);
                    lineCount += 7;
                }
            }
        }      
        
        string footer = string.Format("*END*{0}", lineCount.ToString().PadLeft(8, '0'));
        sw.Write(footer);
        sw.Close();

        FtpWeb ftp = new FtpWeb("ftp://transfert.post.be", "999_parcels", "dkfoec36");
        ftp.Upload(file);

        return file;
    }

    public static void ParseContact(string contact, out string senderId, out string contactNumber, out string subContactNumber)
    {
        //BPI/2009/1234/567
        string[] temps = contact.Split('/');
        if (temps.Length == 3)
        {
            subContactNumber = "000";
        }
        else if (temps.Length == 4)
        {
            subContactNumber = temps[3];
        }
        else
        {
            throw new Exception("Invalid contact.");
        }
        contactNumber = temps[1] + temps[2];
        senderId = "0" + temps[2] + subContactNumber;
    }

    public static string GenerateSequenceId()
    {        
        return "00001";
    }

    public static string GenerateBarcode(string contactNumber, string subContactNumber, string parcelNumber)
    {
        string temp = "41" + contactNumber + subContactNumber + parcelNumber.PadLeft(15, '0');
        decimal d = decimal.Parse(temp);
        decimal xx = d % 97;
        if (xx == 0m)
        {
            xx = 97;
        }
        return (temp + xx.ToString().PadLeft(2, '0')).PadRight(40);
    }

    public static string GeneratePdf(Package p, string barcode)
    {
        Document document = new Document();
        string path = "bpost_files/" + p.Recipient.Order.User + "/CollectionReceiptParcel_" + p.Id.ToString().PadLeft(7, '0') + ".pdf";
        string fileName = HttpRuntime.AppDomainAppPath + path;
        PdfWriter writer = PdfWriter.GetInstance(document, new FileStream(fileName, FileMode.Create));
        document.Open();

        PdfPCell cell;

        PdfPTable from = new PdfPTable(3);
        cell = new PdfPCell(new Phrase("From"));

        from.AddCell(cell);
        cell = new PdfPCell(new Phrase(string.Format("Name:999 PARCEL LTD\nBussiness:PO BOX 9320\nStreet:EMC BRU Cargo\nZip Code:1934\nCountry:BE\nPhonenr:")));
        cell.Colspan = 2;
        from.AddCell(cell);

        iTextSharp.text.Image img = iTextSharp.text.Image.GetInstance(HttpRuntime.AppDomainAppPath + "static/img/bpost_logo.png");
        PdfPTable image = new PdfPTable(1);
        image.AddCell(img);

        PdfPTable to = new PdfPTable(3);
        cell = new PdfPCell(new Phrase("To"));
        to.AddCell(cell);
        cell = new PdfPCell(new Phrase(string.Format("Name:\t{0}\nStreet:\t{1}\n{2}\n{3}", p.Recipient.PyName, p.Recipient.PyAddress, "CHINA", p.Recipient.PyCity)));
        cell.Colspan = 2;
        to.AddCell(cell);

        PdfPTable details = new PdfPTable(1);
        cell = new PdfPCell(new Phrase("Service Level PRIO"));
        details.AddCell(cell);
        cell = new PdfPCell(new Phrase("Importer's reference"));
        details.AddCell(cell);
        cell = new PdfPCell(new Phrase("Importer's contact"));
        details.AddCell(cell);
        cell = new PdfPCell(new Phrase("Seneder's instruction in case of non-delivery"));
        details.AddCell(cell);
        cell = new PdfPCell(new Phrase("RETURN TO SENDER"));
        details.AddCell(cell);
        cell = new PdfPCell(new Phrase("Creation Date"));
        details.AddCell(cell);

        BarcodeWriter barcodeWriter = new BarcodeWriter//312010605000100000000000000447
        {
            Format = BarcodeFormat.CODE_128,
            Options = new EncodingOptions
            {
                Height = 100,
                Width = 600
            }
        };

        Bitmap bitmap = barcodeWriter.Write(barcode);
        string pngFile = HttpRuntime.AppDomainAppPath + "bpost_files/" + p.Recipient.Order.User + "/Parcel" + p.Id.ToString().PadLeft(7, '0') + ".png";
        bitmap.Save(pngFile, System.Drawing.Imaging.ImageFormat.Png);
        PdfPTable imageTable = new PdfPTable(1);

        iTextSharp.text.Image barceode = iTextSharp.text.Image.GetInstance(pngFile);
        cell = new PdfPCell(barceode);
        cell.Border = 0;
        cell.PaddingTop = 20;
        imageTable.AddCell(cell);

        document.Add(from);
        document.Add(image);
        document.Add(to);
        document.Add(details);
        document.Add(imageTable);

        document.NewPage();
        iTextSharp.text.Font font = new iTextSharp.text.Font(iTextSharp.text.Font.FontFamily.HELVETICA, 9, 1);
        iTextSharp.text.Font font70 = new iTextSharp.text.Font(iTextSharp.text.Font.FontFamily.HELVETICA, 7, 0);
        iTextSharp.text.Font font71 = new iTextSharp.text.Font(iTextSharp.text.Font.FontFamily.HELVETICA, 7, 1);

        int noRight = iTextSharp.text.Rectangle.LEFT_BORDER | iTextSharp.text.Rectangle.TOP_BORDER | iTextSharp.text.Rectangle.BOTTOM_BORDER;
        int noLeft = iTextSharp.text.Rectangle.RIGHT_BORDER | iTextSharp.text.Rectangle.TOP_BORDER | iTextSharp.text.Rectangle.BOTTOM_BORDER;
        
        PdfPTable title = new PdfPTable(6);
        PdfPTable content = new PdfPTable(1);

        cell = new PdfPCell(new Phrase("Customs Declaration - CN 23", font));
        cell.Border = 0;
        content.AddCell(cell);
        cell = new PdfPCell(new Phrase("may be opened officially - peut être ouvert d'office", font70));
        cell.Border = 0;
        content.AddCell(cell);
        cell = new PdfPCell(new Phrase(string.Format("                      {0}", barcode), new iTextSharp.text.Font(iTextSharp.text.Font.FontFamily.HELVETICA, 10, 1)));
        cell.Border = 0;
        content.AddCell(cell);
        cell = new PdfPCell(new Phrase(p.TrackNumber, new iTextSharp.text.Font(iTextSharp.text.Font.FontFamily.HELVETICA, 8, 1)));
        cell.Border = 0;
        content.AddCell(cell);

        cell = new PdfPCell(content);
        cell.Colspan = 5;
        cell.Border = 0;
        title.AddCell(cell);

        img = iTextSharp.text.Image.GetInstance(HttpRuntime.AppDomainAppPath + "static/img/bpost_logo.bmp");
        img.Border = 0;
        img.BorderWidth = 0;
        cell = new PdfPCell(img);
        cell.Border = 0;
        title.AddCell(cell);

        from = new PdfPTable(6);
        from.SetTotalWidth(new float[] { 5, 15, 25, 15, 25, 15 });

        cell = new PdfPCell(new Phrase("From"));
        cell.Rowspan = 7;
        cell.HorizontalAlignment = 2;
        cell.Rotation = 90;
        from.AddCell(cell);

        cell = new PdfPCell(new Phrase("Name", font71));
        cell.Border = iTextSharp.text.Rectangle.TOP_BORDER;
        from.AddCell(cell);
        cell = new PdfPCell(new Phrase("999 PARCEL LTD", font70));
        cell.Border = iTextSharp.text.Rectangle.TOP_BORDER;
        cell.Colspan = 3;
        from.AddCell(cell);
        cell = new PdfPCell(new Phrase("Customs ref:", font71));
        cell.Rowspan = 2;
        from.AddCell(cell);
        cell = new PdfPCell(new Phrase("Business", font71));
        cell.Border = 0;
        from.AddCell(cell);
        cell = new PdfPCell(new Phrase(" ", font70));
        cell.Border = 0;
        cell.Colspan = 3;
        from.AddCell(cell);

        cell = new PdfPCell(new Phrase("Street", font71));
        cell.Border = 0;
        from.AddCell(cell);
        cell = new PdfPCell(new Phrase("PO Box 9320", font70));
        cell.Border = 0;
        cell.Colspan = 3;
        from.AddCell(cell);

        cell = new PdfPCell();
        cell.Rowspan = 5;
        cell.Border = noLeft;
        from.AddCell(cell);

        cell = new PdfPCell(new Phrase("Zipcode", font71));
        cell.Border = 0;
        from.AddCell(cell);
        cell = new PdfPCell(new Phrase("1934", font70));
        cell.Border = 0;
        from.AddCell(cell);
        cell = new PdfPCell(new Phrase("City", font71));
        cell.Border = 0;
        from.AddCell(cell);
        cell = new PdfPCell(new Phrase("EMC Brucargo", font70));
        cell.Border = 0;
        from.AddCell(cell);
        cell = new PdfPCell(new Phrase("Country", font71));
        cell.Border = 0;
        from.AddCell(cell);
        cell = new PdfPCell(new Phrase("Belgium", font70));
        cell.Border = 0;
        cell.Colspan = 3;
        from.AddCell(cell);
        cell = new PdfPCell(new Phrase("Tel*", font71));
        cell.Border = 0;
        from.AddCell(cell);
        cell = new PdfPCell(new Phrase("", font70));
        cell.Border = 0;
        cell.Colspan = 3;
        from.AddCell(cell);
        cell = new PdfPCell(new Phrase("Email*", font71));
        cell.Border = 0;
        from.AddCell(cell);
        cell = new PdfPCell(new Phrase("", font70));
        cell.Border = 0;
        cell.Colspan = 3;
        from.AddCell(cell);

        to = new PdfPTable(6);
        to.SetTotalWidth(new float[] { 5, 15, 25, 15, 25, 15 });

        cell = new PdfPCell(new Phrase("To"));
        cell.Rowspan = 7;
        cell.HorizontalAlignment = 2;
        cell.Rotation = 90;
        to.AddCell(cell);

        cell = new PdfPCell(new Phrase("Name", font71));
        cell.Border = iTextSharp.text.Rectangle.TOP_BORDER;
        to.AddCell(cell);
        cell = new PdfPCell(new Phrase(p.Recipient.PyName, font70));
        cell.Border = iTextSharp.text.Rectangle.TOP_BORDER;
        cell.Colspan = 3;
        to.AddCell(cell);
        cell = new PdfPCell(new Phrase("Importer ref:", font71));
        cell.Rowspan = 2;
        to.AddCell(cell);
        cell = new PdfPCell(new Phrase("Business", font71));
        cell.Border = 0;
        to.AddCell(cell);
        cell = new PdfPCell(new Phrase(p.Recipient.PyName, font70));
        cell.Border = 0;
        cell.Colspan = 3;
        to.AddCell(cell);

        cell = new PdfPCell(new Phrase("Street", font71));
        cell.Border = 0;
        to.AddCell(cell);
        cell = new PdfPCell(new Phrase(p.Recipient.PyAddress, font70));
        cell.Colspan = 3;
        cell.Border = 0;
        to.AddCell(cell);

        cell = new PdfPCell();
        cell.Rowspan = 5;
        cell.Border = noLeft;
        to.AddCell(cell);

        cell = new PdfPCell(new Phrase("Zipcode", font71));
        cell.Border = 0;
        to.AddCell(cell);
        cell = new PdfPCell(new Phrase(p.Recipient.ZipCode, font70));
        cell.Border = 0;
        to.AddCell(cell);
        cell = new PdfPCell(new Phrase("City", font71));
        cell.Border = 0;
        to.AddCell(cell);
        cell = new PdfPCell(new Phrase(p.Recipient.PyCity, font70));
        cell.Border = 0;
        to.AddCell(cell);
        cell = new PdfPCell(new Phrase("Country", font71));
        cell.Border = 0;
        to.AddCell(cell);
        cell = new PdfPCell(new Phrase("China", font70));
        cell.Border = 0;
        cell.Colspan = 3;
        to.AddCell(cell);
        cell = new PdfPCell(new Phrase("Tel*", font71));
        cell.Border = 0;
        to.AddCell(cell);
        cell = new PdfPCell(new Phrase(p.Recipient.PhoneNumber, font70));
        cell.Border = 0;
        cell.Colspan = 3;
        to.AddCell(cell);
        cell = new PdfPCell(new Phrase("Email*", font71));
        cell.Border = 0;
        to.AddCell(cell);
        cell = new PdfPCell(new Phrase("alanmelai@hotmail.com", font70));
        cell.Border = 0;
        cell.Colspan = 3;
        to.AddCell(cell);

        PdfPTable tableTo = new PdfPTable(1);
        PdfPCell cellTo = new PdfPCell(to);
        cellTo.BorderWidth = 2;
        tableTo.AddCell(cellTo);

        PdfPTable info = new PdfPTable(2);
        info.SetTotalWidth(new float[] { 38, 62 });
        cell = new PdfPCell(new Phrase("Sender's instruction in case of non-delivery:", font71));
        cell.Border = noRight;
        info.AddCell(cell);
        cell = new PdfPCell(new Phrase("RETURN TO SENDER (SAL)", font70));
        cell.Border = noLeft;
        info.AddCell(cell);

        PdfPTable cate = new PdfPTable(4);
        cate.SetTotalWidth(new float[] { 15, 25, 40, 20 });
        cell = new PdfPCell(new Phrase("Category of item:", font71));
        cell.Border = noRight;
        cate.AddCell(cell);
        cell = new PdfPCell(new Phrase("GIFT", font70));
        cell.Border = iTextSharp.text.Rectangle.TOP_BORDER;
        cate.AddCell(cell);
        cell = new PdfPCell(new Phrase("Explanation:", font71));
        cell.Border = iTextSharp.text.Rectangle.TOP_BORDER;
        cate.AddCell(cell);
        cell = new PdfPCell(new Phrase("", font70));
        cell.Border = noLeft;
        cate.AddCell(cell);
        cell = new PdfPCell(new Phrase("Service level:", font71));
        cell.Border = noRight;
        cate.AddCell(cell);
        cell = new PdfPCell(new Phrase("PRI", font70));
        cell.Border = iTextSharp.text.Rectangle.TOP_BORDER;
        cate.AddCell(cell);
        cell = new PdfPCell(new Phrase("Customs documents to be validated for export:", font71));
        cell.Border = iTextSharp.text.Rectangle.TOP_BORDER;
        cate.AddCell(cell);
        cell = new PdfPCell(new Phrase("NO", font70));
        cell.Border = noLeft;
        cate.AddCell(cell);

        PdfPTable detail = new PdfPTable(6);
        detail.SetTotalWidth(new float[] { 20, 20, 9, 9, 12, 30 });
        cell = new PdfPCell(new Phrase("Comments (e.g. quarantine...):", font71));
        cell.Colspan = 5;
        detail.AddCell(cell);



        PdfPTable comTable = new PdfPTable(2);

        PdfPCell comCell = new PdfPCell(new Phrase("Commercial items only", new iTextSharp.text.Font(iTextSharp.text.Font.FontFamily.HELVETICA, 7, 2)));
        comCell.Colspan = 2;
        comCell.HorizontalAlignment = 1;
        comTable.AddCell(comCell);
        comCell = new PdfPCell(new Phrase("HS Tariff N°", font71));
        comCell.HorizontalAlignment = 1;
        comTable.AddCell(comCell);
        comCell = new PdfPCell(new Phrase("Origin of goods", font71));
        comCell.HorizontalAlignment = 1;
        comTable.AddCell(comCell);
        for (int i = 0; i < 10; i++)
        {
            comCell = new PdfPCell(new Phrase(" ", font71));
            comTable.AddCell(comCell);
            if (i < p.PackageItems.Count)
            {
                comCell = new PdfPCell(new Phrase("UK", font70));
            }
            else
            {
                comCell = new PdfPCell();
            }
            comCell.HorizontalAlignment = 1;
            comTable.AddCell(comCell);
        }

        cell = new PdfPCell(comTable);
        cell.BorderWidth = 2;
        cell.Rowspan = 12;
        detail.AddCell(cell);

        cell = new PdfPCell(new Phrase("Detailed Description of Contents", font71));
        cell.Colspan = 2;
        cell.HorizontalAlignment = 1;
        detail.AddCell(cell);
        cell = new PdfPCell(new Phrase("Qty", font71));
        cell.HorizontalAlignment = 1;
        detail.AddCell(cell);
        cell = new PdfPCell(new Phrase("Net kg", font71));
        cell.HorizontalAlignment = 1;
        detail.AddCell(cell);
        cell = new PdfPCell(new Phrase("Value", font71));
        cell.HorizontalAlignment = 1;
        detail.AddCell(cell);

        for (int i = 0; i < 10; i++)
        {
            if (i < p.PackageItems.Count)
            {
                PackageItem item = p.PackageItems.ElementAt(i);
                cell = new PdfPCell(new Phrase(item.Description, font70));
                cell.Colspan = 2;
                detail.AddCell(cell);

                cell = new PdfPCell(new Phrase(item.Count.ToString(), font70));
                cell.HorizontalAlignment = 1;
                detail.AddCell(cell);
                cell = new PdfPCell(new Phrase(item.NettoWeight.Value.ToString(), font70));
                cell.HorizontalAlignment = 1;
                detail.AddCell(cell);
                cell = new PdfPCell(new Phrase(item.Value.Value.ToString() + " GBP", font70));
                cell.HorizontalAlignment = 1;
                detail.AddCell(cell);
            }
            else
            {
                cell = new PdfPCell(new Phrase(" ", font70));
                cell.Colspan = 2;
                detail.AddCell(cell);

                cell = new PdfPCell();
                detail.AddCell(cell);
                cell = new PdfPCell();
                detail.AddCell(cell);
                cell = new PdfPCell();
                detail.AddCell(cell);
            }            
        }

        cell = new PdfPCell(new Phrase("Total gross weight:", font71));
        cell.Border = noRight;
        detail.AddCell(cell);
        cell = new PdfPCell(new Phrase(string.Format("{0}kg", p.Weight), font70));
        cell.Border = noLeft;
        detail.AddCell(cell);
        cell = new PdfPCell(new Phrase("Postage fee:                       License:                        Certificate:", font71));
        cell.Colspan = 5;
        detail.AddCell(cell);
        cell = new PdfPCell(new Phrase("Total value:", font71));
        cell.Border = noRight;
        detail.AddCell(cell);
        cell = new PdfPCell(new Phrase(string.Format("{0} GBP", p.Value), font70));
        cell.Border = noLeft;
        detail.AddCell(cell);
        cell = new PdfPCell(new Phrase("Invoice:                               Office & date of posting:", font71));
        cell.Colspan = 5;
        detail.AddCell(cell);

        PdfPTable notice = new PdfPTable(1);
        Phrase phrase = new Phrase("I certify that the particulars in this customs declaration are correct and this item does not contain any dangerous articles prohibited by legislation or by postal or customs regulations. These data shall be transmitted to the destination country operator and to customs authorities to pre-announce shipments (except for the information marked with (*): this is only used for delivery purposes). Unless you thick the box below, data related to the sender and addressee may also be used for the provision of information as to our services. As sender, you confirm having duly informed the addressee of these intended uses and having obtained his/her consent. The sender or addressee may request in writing the provision of its personal data as held in our registers by sending a signed and dated request to bpost, Contact Center, PO box 5000, 1000 Brussels, Belgium.\n\n[ ] I do not wish that my personal data and the personal data related to the addressee be used by bpost/its affiliates for providing us with information as to their services.\n\n", new iTextSharp.text.Font(iTextSharp.text.Font.FontFamily.HELVETICA, 6, 0));
        phrase.Add(new Phrase("Date and sender signature:", font71));
        phrase.Add(new Phrase(string.Format(" {0}", DateTime.Today.ToString("dd/MM/yyyy")), font70));
        cell = new PdfPCell(phrase);
        notice.AddCell(cell);

        document.Add(title);
        document.Add(from);
        document.Add(tableTo);
        document.Add(info);
        document.Add(cate);
        document.Add(detail);
        document.Add(notice);

        document.Close();

        return path;
    }

    public static void GenerateLabel(Package p, string barcode)
    {
        Document document = new Document();
        string fileName = HttpRuntime.AppDomainAppPath + "bpost_files/" + p.Recipient.Order.User + "/CollectionReceiptParcel_" + p.Id.ToString().PadLeft(7, '0') + ".pdf";
        PdfWriter writer = PdfWriter.GetInstance(document, new FileStream(fileName, FileMode.Create));
        document.Open();

        PdfPCell cell;

        PdfPTable from = new PdfPTable(3);
        cell = new PdfPCell(new Phrase("From"));

        from.AddCell(cell);
        cell = new PdfPCell(new Phrase(string.Format("Name:999 PARCEL LTD\nBussiness:PO BOX 9320\nStreet:EMC BRU Cargo\nZip Code:1934\nCountry:BE\nPhonenr:")));
        cell.Colspan = 2;
        from.AddCell(cell);

        iTextSharp.text.Image img = iTextSharp.text.Image.GetInstance(HttpRuntime.AppDomainAppPath + "static/img/bpost_logo.png");
        PdfPTable image = new PdfPTable(1);
        image.AddCell(img);

        PdfPTable to = new PdfPTable(3);
        cell = new PdfPCell(new Phrase("To"));
        to.AddCell(cell);
        cell = new PdfPCell(new Phrase(string.Format("Name:\t{0}\nStreet:\t{1}\n{2}\n{3}", p.Recipient.PyName, p.Recipient.PyAddress, "CHINA", p.Recipient.PyCity)));
        cell.Colspan = 2;
        to.AddCell(cell);

        PdfPTable details = new PdfPTable(1);
        cell = new PdfPCell(new Phrase("Service Level PRIO"));
        details.AddCell(cell);
        cell = new PdfPCell(new Phrase("Importer's reference"));
        details.AddCell(cell);
        cell = new PdfPCell(new Phrase("Importer's contact"));
        details.AddCell(cell);
        cell = new PdfPCell(new Phrase("Seneder's instruction in case of non-delivery"));
        details.AddCell(cell);
        cell = new PdfPCell(new Phrase("RETURN TO SENDER"));
        details.AddCell(cell);
        cell = new PdfPCell(new Phrase("Creation Date"));
        details.AddCell(cell);

        BarcodeWriter barcodeWriter = new BarcodeWriter//312010605000100000000000000447
        {
            Format = BarcodeFormat.CODE_128,
            Options = new EncodingOptions
            {
                Height = 100,
                Width = 600
            }
        };

        Bitmap bitmap = barcodeWriter.Write(barcode);
        string pngFile = HttpRuntime.AppDomainAppPath + "bpost_files/" + p.Recipient.Order.User + "/Parcel" + p.Id.ToString().PadLeft(7, '0') + ".png";
        bitmap.Save(pngFile, System.Drawing.Imaging.ImageFormat.Png);
        iTextSharp.text.Image barceode = iTextSharp.text.Image.GetInstance(pngFile);
        barceode.SetAbsolutePosition(0, 350);

        document.Add(from);
        document.Add(image);
        document.Add(to);
        document.Add(details);
        document.Add(barceode);

        document.Close();
    }

    public static void GenerateCN23(Package p, string barcode)
    {
        Document document = new Document();
        string fileName = HttpRuntime.AppDomainAppPath + "bpost_files/" + p.Recipient.Order.User + "/CN23_" + p.Id.ToString().PadLeft(7, '0') + ".pdf"; ;
        PdfWriter writer = PdfWriter.GetInstance(document, new FileStream(fileName, FileMode.Create));
        document.Open();

        iTextSharp.text.Font font = new iTextSharp.text.Font(iTextSharp.text.Font.FontFamily.HELVETICA, 9, 1);
        iTextSharp.text.Font font70 = new iTextSharp.text.Font(iTextSharp.text.Font.FontFamily.HELVETICA, 7, 0);
        iTextSharp.text.Font font71 = new iTextSharp.text.Font(iTextSharp.text.Font.FontFamily.HELVETICA, 7, 1);

        int noRight = iTextSharp.text.Rectangle.LEFT_BORDER | iTextSharp.text.Rectangle.TOP_BORDER | iTextSharp.text.Rectangle.BOTTOM_BORDER;
        int noLeft = iTextSharp.text.Rectangle.RIGHT_BORDER | iTextSharp.text.Rectangle.TOP_BORDER | iTextSharp.text.Rectangle.BOTTOM_BORDER;        

        PdfPCell cell;

        PdfPTable title = new PdfPTable(6);
        PdfPTable content = new PdfPTable(1);

        cell = new PdfPCell(new Phrase("Customs Declaration - CN 23", font));
        cell.Border = 0;
        content.AddCell(cell);
        cell = new PdfPCell(new Phrase("may be opened officially - peut être ouvert d'office", font70));
        cell.Border = 0;
        content.AddCell(cell);
        cell = new PdfPCell(new Phrase(string.Format("                      {0}", barcode), new iTextSharp.text.Font(iTextSharp.text.Font.FontFamily.HELVETICA, 10, 1)));
        cell.Border = 0;
        content.AddCell(cell);
        cell = new PdfPCell(new Phrase(p.TrackNumber, new iTextSharp.text.Font(iTextSharp.text.Font.FontFamily.HELVETICA, 8, 1)));
        cell.Border = 0;
        content.AddCell(cell);

        cell = new PdfPCell(content);
        cell.Colspan = 5;
        cell.Border = 0;
        title.AddCell(cell);


        iTextSharp.text.Image img = iTextSharp.text.Image.GetInstance("bpost_logo.bmp");
        img.Border = 0;
        img.BorderWidth = 0;
        cell = new PdfPCell(img);
        cell.Border = 0;
        title.AddCell(cell);

        PdfPTable from = new PdfPTable(6);
        from.SetTotalWidth(new float[] { 5, 15, 25, 15, 25, 15 });

        cell = new PdfPCell(new Phrase("From"));
        cell.Rowspan = 7;
        cell.HorizontalAlignment = 2;
        cell.Rotation = 90;
        from.AddCell(cell);

        cell = new PdfPCell(new Phrase("Name", font71));
        cell.Border = iTextSharp.text.Rectangle.TOP_BORDER;
        from.AddCell(cell);
        cell = new PdfPCell(new Phrase("999 PARCEL LTD", font70));
        cell.Border = iTextSharp.text.Rectangle.TOP_BORDER;
        cell.Colspan = 3;
        from.AddCell(cell);
        cell = new PdfPCell(new Phrase("Customs ref:", font71));
        cell.Rowspan = 2;
        from.AddCell(cell);
        cell = new PdfPCell(new Phrase("Business", font71));
        cell.Border = 0;
        from.AddCell(cell);
        cell = new PdfPCell(new Phrase(" ", font70));
        cell.Border = 0;
        cell.Colspan = 3;
        from.AddCell(cell);

        cell = new PdfPCell(new Phrase("Street", font71));
        cell.Border = 0;
        from.AddCell(cell);
        cell = new PdfPCell(new Phrase("PO Box 9320", font70));
        cell.Border = 0;
        cell.Colspan = 3;
        from.AddCell(cell);

        cell = new PdfPCell();
        cell.Rowspan = 5;
        cell.Border = noLeft;
        from.AddCell(cell);

        cell = new PdfPCell(new Phrase("Zipcode", font71));
        cell.Border = 0;
        from.AddCell(cell);
        cell = new PdfPCell(new Phrase("1934", font70));
        cell.Border = 0;
        from.AddCell(cell);
        cell = new PdfPCell(new Phrase("City", font71));
        cell.Border = 0;
        from.AddCell(cell);
        cell = new PdfPCell(new Phrase("EMC Brucargo", font70));
        cell.Border = 0;
        from.AddCell(cell);
        cell = new PdfPCell(new Phrase("Country", font71));
        cell.Border = 0;
        from.AddCell(cell);
        cell = new PdfPCell(new Phrase("Belgium", font70));
        cell.Border = 0;
        cell.Colspan = 3;
        from.AddCell(cell);
        cell = new PdfPCell(new Phrase("Tel*", font71));
        cell.Border = 0;
        from.AddCell(cell);
        cell = new PdfPCell(new Phrase("", font70));
        cell.Border = 0;
        cell.Colspan = 3;
        from.AddCell(cell);
        cell = new PdfPCell(new Phrase("Email*", font71));
        cell.Border = 0;
        from.AddCell(cell);
        cell = new PdfPCell(new Phrase("", font70));
        cell.Border = 0;
        cell.Colspan = 3;
        from.AddCell(cell);



        PdfPTable to = new PdfPTable(6);
        to.SetTotalWidth(new float[] { 5, 15, 25, 15, 25, 15 });

        cell = new PdfPCell(new Phrase("To"));
        cell.Rowspan = 7;
        cell.HorizontalAlignment = 2;
        cell.Rotation = 90;
        to.AddCell(cell);

        cell = new PdfPCell(new Phrase("Name", font71));
        cell.Border = iTextSharp.text.Rectangle.TOP_BORDER;
        to.AddCell(cell);
        cell = new PdfPCell(new Phrase(p.Recipient.PyName, font70));
        cell.Border = iTextSharp.text.Rectangle.TOP_BORDER;
        cell.Colspan = 3;
        to.AddCell(cell);
        cell = new PdfPCell(new Phrase("Importer ref:", font71));
        cell.Rowspan = 2;
        to.AddCell(cell);
        cell = new PdfPCell(new Phrase("Business", font71));
        cell.Border = 0;
        to.AddCell(cell);
        cell = new PdfPCell(new Phrase(p.Recipient.PyName, font70));
        cell.Border = 0;
        cell.Colspan = 3;
        to.AddCell(cell);

        cell = new PdfPCell(new Phrase("Street", font71));
        cell.Border = 0;
        to.AddCell(cell);
        cell = new PdfPCell(new Phrase(p.Recipient.PyAddress, font70));
        cell.Colspan = 3;
        cell.Border = 0;
        to.AddCell(cell);

        cell = new PdfPCell();
        cell.Rowspan = 5;
        cell.Border = noLeft;
        to.AddCell(cell);

        cell = new PdfPCell(new Phrase("Zipcode", font71));
        cell.Border = 0;
        to.AddCell(cell);
        cell = new PdfPCell(new Phrase(p.Recipient.ZipCode, font70));
        cell.Border = 0;
        to.AddCell(cell);
        cell = new PdfPCell(new Phrase("City", font71));
        cell.Border = 0;
        to.AddCell(cell);
        cell = new PdfPCell(new Phrase(p.Recipient.PyCity, font70));
        cell.Border = 0;
        to.AddCell(cell);
        cell = new PdfPCell(new Phrase("Country", font71));
        cell.Border = 0;
        to.AddCell(cell);
        cell = new PdfPCell(new Phrase("China", font70));
        cell.Border = 0;
        cell.Colspan = 3;
        to.AddCell(cell);
        cell = new PdfPCell(new Phrase("Tel*", font71));
        cell.Border = 0;
        to.AddCell(cell);
        cell = new PdfPCell(new Phrase(p.Recipient.PhoneNumber, font70));
        cell.Border = 0;
        cell.Colspan = 3;
        to.AddCell(cell);
        cell = new PdfPCell(new Phrase("Email*", font71));
        cell.Border = 0;
        to.AddCell(cell);
        cell = new PdfPCell(new Phrase("alanmelai@hotmail.com", font70));
        cell.Border = 0;
        cell.Colspan = 3;
        to.AddCell(cell);

        PdfPTable tableTo = new PdfPTable(1);
        PdfPCell cellTo = new PdfPCell(to);
        cellTo.BorderWidth = 2;
        tableTo.AddCell(cellTo);

        PdfPTable info = new PdfPTable(2);
        info.SetTotalWidth(new float[] { 38, 62 });
        cell = new PdfPCell(new Phrase("Sender's instruction in case of non-delivery:", font71));
        cell.Border = noRight;
        info.AddCell(cell);
        cell = new PdfPCell(new Phrase("RETURN TO SENDER (SAL)", font70));
        cell.Border = noLeft;
        info.AddCell(cell);

        PdfPTable cate = new PdfPTable(4);
        cate.SetTotalWidth(new float[] { 15, 25, 40, 20 });
        cell = new PdfPCell(new Phrase("Category of item:", font71));
        cell.Border = noRight;
        cate.AddCell(cell);
        cell = new PdfPCell(new Phrase("GIFT", font70));
        cell.Border = iTextSharp.text.Rectangle.TOP_BORDER;
        cate.AddCell(cell);
        cell = new PdfPCell(new Phrase("Explanation:", font71));
        cell.Border = iTextSharp.text.Rectangle.TOP_BORDER;
        cate.AddCell(cell);
        cell = new PdfPCell(new Phrase("", font70));
        cell.Border = noLeft;
        cate.AddCell(cell);
        cell = new PdfPCell(new Phrase("Service level:", font71));
        cell.Border = noRight;
        cate.AddCell(cell);
        cell = new PdfPCell(new Phrase("PRI", font70));
        cell.Border = iTextSharp.text.Rectangle.TOP_BORDER;
        cate.AddCell(cell);
        cell = new PdfPCell(new Phrase("Customs documents to be validated for export:", font71));
        cell.Border = iTextSharp.text.Rectangle.TOP_BORDER;
        cate.AddCell(cell);
        cell = new PdfPCell(new Phrase("NO", font70));
        cell.Border = noLeft;
        cate.AddCell(cell);

        PdfPTable detail = new PdfPTable(6);
        detail.SetTotalWidth(new float[] { 20, 20, 9, 9, 12, 30 });
        cell = new PdfPCell(new Phrase("Comments (e.g. quarantine...):", font71));
        cell.Colspan = 5;
        detail.AddCell(cell);



        PdfPTable comTable = new PdfPTable(2);

        PdfPCell comCell = new PdfPCell(new Phrase("Commercial items only", new iTextSharp.text.Font(iTextSharp.text.Font.FontFamily.HELVETICA, 7, 2)));
        comCell.Colspan = 2;
        comCell.HorizontalAlignment = 1;
        comTable.AddCell(comCell);
        comCell = new PdfPCell(new Phrase("HS Tariff N°", font71));
        comCell.HorizontalAlignment = 1;
        comTable.AddCell(comCell);
        comCell = new PdfPCell(new Phrase("Origin of goods", font71));
        comCell.HorizontalAlignment = 1;
        comTable.AddCell(comCell);
        for (int i = 0; i < 20; i++)
        {
            comCell = new PdfPCell(new Phrase(" ", font71));
            comTable.AddCell(comCell);
        }

        cell = new PdfPCell(comTable);
        cell.BorderWidth = 2;
        cell.Rowspan = 12;
        detail.AddCell(cell);

        cell = new PdfPCell(new Phrase("Detailed Description of Contents", font71));
        cell.Colspan = 2;
        cell.HorizontalAlignment = 1;
        detail.AddCell(cell);
        cell = new PdfPCell(new Phrase("Qty", font71));
        cell.HorizontalAlignment = 1;
        detail.AddCell(cell);
        cell = new PdfPCell(new Phrase("Net kg", font71));
        cell.HorizontalAlignment = 1;
        detail.AddCell(cell);
        cell = new PdfPCell(new Phrase("Value", font71));
        cell.HorizontalAlignment = 1;
        detail.AddCell(cell);        

        for (int i = 0; i < 10; i++)
        {
            cell = new PdfPCell(new Phrase(p.PackageItems.ElementAt(i).Description, font70));
            cell.Colspan = 2;
            detail.AddCell(cell);
            cell = new PdfPCell();
            detail.AddCell(cell);
            cell = new PdfPCell();
            detail.AddCell(cell);
            cell = new PdfPCell();
            detail.AddCell(cell);
        }

        cell = new PdfPCell(new Phrase("Total gross weight:", font71));
        cell.Border = noRight;
        detail.AddCell(cell);
        cell = new PdfPCell(new Phrase(string.Format("{0}kg", p.Weight), font70));
        cell.Border = noLeft;
        detail.AddCell(cell);
        cell = new PdfPCell(new Phrase("Postage fee:                       License:                        Certificate:", font71));
        cell.Colspan = 5;
        detail.AddCell(cell);
        cell = new PdfPCell(new Phrase("Total value:", font71));
        cell.Border = noRight;
        detail.AddCell(cell);
        cell = new PdfPCell(new Phrase(string.Format("{0} GBP", p.Value), font70));
        cell.Border = noLeft;
        detail.AddCell(cell);
        cell = new PdfPCell(new Phrase("Invoice:                               Office & date of posting:", font71));
        cell.Colspan = 5;
        detail.AddCell(cell);

        PdfPTable notice = new PdfPTable(1);
        Phrase phrase = new Phrase("I certify that the particulars in this customs declaration are correct and this item does not contain any dangerous articles prohibited by legislation or by postal or customs regulations. These data shall be transmitted to the destination country operator and to customs authorities to pre-announce shipments (except for the information marked with (*): this is only used for delivery purposes). Unless you thick the box below, data related to the sender and addressee may also be used for the provision of information as to our services. As sender, you confirm having duly informed the addressee of these intended uses and having obtained his/her consent. The sender or addressee may request in writing the provision of its personal data as held in our registers by sending a signed and dated request to bpost, Contact Center, PO box 5000, 1000 Brussels, Belgium.\n\n[ ] I do not wish that my personal data and the personal data related to the addressee be used by bpost/its affiliates for providing us with information as to their services.\n\n", new iTextSharp.text.Font(iTextSharp.text.Font.FontFamily.HELVETICA, 6, 0));
        phrase.Add(new Phrase("Date and sender signature:", font71));
        phrase.Add(new Phrase(string.Format(" {0}", DateTime.Today.ToString("dd/MM/yyyy")), font70));
        cell = new PdfPCell(phrase);
        notice.AddCell(cell);

        document.Add(title);
        document.Add(from);
        document.Add(tableTo);
        document.Add(info);
        document.Add(cate);
        document.Add(detail);
        document.Add(notice);

        document.Close();
    }
}