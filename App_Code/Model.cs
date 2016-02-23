﻿//------------------------------------------------------------------------------
// <auto-generated>
//     This code was generated from a template.
//
//     Manual changes to this file may cause unexpected behavior in your application.
//     Manual changes to this file will be overwritten if the code is regenerated.
// </auto-generated>
//------------------------------------------------------------------------------

using System;
using System.Collections.Generic;

public partial class aspnet_User
{
    public System.Guid ApplicationId { get; set; }
    public System.Guid UserId { get; set; }
    public string UserName { get; set; }
    public string LoweredUserName { get; set; }
    public string MobileAlias { get; set; }
    public bool IsAnonymous { get; set; }
    public System.DateTime LastActivityDate { get; set; }
    public decimal Balance { get; set; }
    public string FirstName { get; set; }
    public string LastName { get; set; }
    public string CellPhone { get; set; }
}

public partial class News
{
    public int Id { get; set; }
    public string Title { get; set; }
    public string Content { get; set; }
    public System.DateTime PulishTime { get; set; }
}

public partial class Order
{
    public Order()
    {
        this.Recipients = new HashSet<Recipient>();
    }

    public int Id { get; set; }
    public string User { get; set; }
    public Nullable<System.DateTime> OrderTime { get; set; }
    public Nullable<int> ServiceID { get; set; }
    public Nullable<bool> HasPaid { get; set; }
    public Nullable<System.DateTime> PickupTime { get; set; }
    public Nullable<bool> IsValid { get; set; }
    public string SenderName { get; set; }
    public string SenderCity { get; set; }
    public string SenderAddress1 { get; set; }
    public string SenderAddress2 { get; set; }
    public string SenderAddress3 { get; set; }
    public string SenderPhone { get; set; }
    public string SenderZipCode { get; set; }
    public Nullable<int> ReinforceID { get; set; }
    public Nullable<bool> IsSheffieldOrder { get; set; }
    public Nullable<int> SheffieldOrderID { get; set; }
    public Nullable<int> SheffieldServiceID { get; set; }
    public Nullable<int> PriceListID { get; set; }
    public Nullable<decimal> Cost { get; set; }
    public string SenderEmail { get; set; }
    public Nullable<bool> SuccessPaid { get; set; }
    public string UKMConsignmentNumber { get; set; }
    public string UKMErrors { get; set; }

    public virtual ICollection<Recipient> Recipients { get; set; }
    public virtual Reinforce Reinforce { get; set; }
    public virtual Service Service { get; set; }
    public virtual SheffieldOrder SheffieldOrder { get; set; }
    public virtual SheffieldService SheffieldService { get; set; }
    public virtual PriceList PriceList { get; set; }
}

public partial class Package
{
    public Package()
    {
        this.PackageItems = new HashSet<PackageItem>();
    }

    public int Id { get; set; }
    public decimal Length { get; set; }
    public decimal Width { get; set; }
    public decimal Height { get; set; }
    public decimal Weight { get; set; }
    public int RecipientID { get; set; }
    public string Detail { get; set; }
    public Nullable<decimal> Value { get; set; }
    public string TrackNumber { get; set; }
    public string Response { get; set; }
    public string Status { get; set; }
    public string Pdf { get; set; }

    public virtual Recipient Recipient { get; set; }
    public virtual ICollection<PackageItem> PackageItems { get; set; }
}

public partial class PackageItem
{
    public int Id { get; set; }
    public Nullable<decimal> Value { get; set; }
    public string Description { get; set; }
    public Nullable<decimal> NettoWeight { get; set; }
    public string TariffCode { get; set; }
    public Nullable<int> PackageID { get; set; }
    public Nullable<int> Count { get; set; }

    public virtual Package Package { get; set; }
}

public partial class PriceItem
{
    public int Id { get; set; }
    public decimal Weight { get; set; }
    public decimal Price { get; set; }
    public int PriceListID { get; set; }

    public virtual PriceList PriceList { get; set; }
}

public partial class PriceList
{
    public PriceList()
    {
        this.PriceItems = new HashSet<PriceItem>();
        this.Services = new HashSet<Service>();
        this.Orders = new HashSet<Order>();
    }

    public int Id { get; set; }
    public string Name { get; set; }
    public string ShortName { get; set; }

    public virtual ICollection<PriceItem> PriceItems { get; set; }
    public virtual ICollection<Service> Services { get; set; }
    public virtual ICollection<Order> Orders { get; set; }
}

public partial class RechargeApply
{
    public int Id { get; set; }
    public int ChannelID { get; set; }
    public decimal ApplyAmount { get; set; }
    public string Evidence { get; set; }
    public Nullable<decimal> ApprovedAmount { get; set; }
    public Nullable<bool> IsApproved { get; set; }
    public string User { get; set; }
    public string Wangwang { get; set; }
    public Nullable<System.DateTime> Time { get; set; }

    public virtual RechargeChannel RechargeChannel { get; set; }
}

public partial class RechargeChannel
{
    public RechargeChannel()
    {
        this.RechargeApplys = new HashSet<RechargeApply>();
    }

    public int Id { get; set; }
    public string Name { get; set; }

    public virtual ICollection<RechargeApply> RechargeApplys { get; set; }
}

public partial class Recipient
{
    public Recipient()
    {
        this.Packages = new HashSet<Package>();
    }

    public int Id { get; set; }
    public string Name { get; set; }
    public string City { get; set; }
    public string Address { get; set; }
    public string ZipCode { get; set; }
    public string PhoneNumber { get; set; }
    public Nullable<int> OrderId { get; set; }
    public Nullable<bool> SuccessPaid { get; set; }
    public string Errors { get; set; }
    public string WMLeaderNumber { get; set; }
    public string WMLeaderPdf { get; set; }
    public string PyName { get; set; }
    public string PyCity { get; set; }
    public string PyAddress { get; set; }
    public string Email { get; set; }

    public virtual Order Order { get; set; }
    public virtual ICollection<Package> Packages { get; set; }
}

public partial class Reinforce
{
    public Reinforce()
    {
        this.Orders = new HashSet<Order>();
    }

    public int Id { get; set; }
    public string Type { get; set; }
    public Nullable<decimal> Price { get; set; }
    public string Describe { get; set; }
    public string PictureLink { get; set; }

    public virtual ICollection<Order> Orders { get; set; }
}

public partial class Service
{
    public Service()
    {
        this.Orders = new HashSet<Order>();
    }

    public int Id { get; set; }
    public string Name { get; set; }
    public string PictureLink { get; set; }
    public string Discribe { get; set; }
    public string DiscribePictureLink { get; set; }
    public bool PickUpService { get; set; }
    public Nullable<int> PriceListID { get; set; }
    public string PickUpCompany { get; set; }

    public virtual ICollection<Order> Orders { get; set; }
    public virtual PriceList PriceList { get; set; }
}

public partial class SheffieldOrder
{
    public SheffieldOrder()
    {
        this.Orders = new HashSet<Order>();
    }

    public int Id { get; set; }
    public string User { get; set; }

    public virtual ICollection<Order> Orders { get; set; }
}

public partial class SheffieldService
{
    public SheffieldService()
    {
        this.Orders = new HashSet<Order>();
    }

    public int Id { get; set; }
    public string Name { get; set; }
    public string PictureLink { get; set; }
    public string Discribe1 { get; set; }
    public string Discribe2 { get; set; }
    public string DiscribePictureLink { get; set; }
    public decimal ReinforcePrice { get; set; }
    public decimal PackageWeight { get; set; }
    public decimal PackageLength { get; set; }
    public decimal PackageWidth { get; set; }
    public decimal PackageHeight { get; set; }

    public virtual ICollection<Order> Orders { get; set; }
}

public partial class aspnet_Membership_GetPassword_Result
{
    public string Column1 { get; set; }
    public Nullable<int> Column2 { get; set; }
}

public partial class aspnet_Membership_GetPasswordWithFormat_Result
{
    public string Column1 { get; set; }
    public Nullable<int> Column2 { get; set; }
    public string Column3 { get; set; }
    public Nullable<int> Column4 { get; set; }
    public Nullable<int> Column5 { get; set; }
    public Nullable<bool> Column6 { get; set; }
    public Nullable<System.DateTime> Column7 { get; set; }
    public Nullable<System.DateTime> Column8 { get; set; }
}

public partial class aspnet_Membership_GetUserByName_Result
{
    public string Email { get; set; }
    public string PasswordQuestion { get; set; }
    public string Comment { get; set; }
    public bool IsApproved { get; set; }
    public System.DateTime CreateDate { get; set; }
    public System.DateTime LastLoginDate { get; set; }
    public System.DateTime LastActivityDate { get; set; }
    public System.DateTime LastPasswordChangedDate { get; set; }
    public System.Guid UserId { get; set; }
    public bool IsLockedOut { get; set; }
    public System.DateTime LastLockoutDate { get; set; }
}

public partial class aspnet_Membership_GetUserByUserId_Result
{
    public string Email { get; set; }
    public string PasswordQuestion { get; set; }
    public string Comment { get; set; }
    public bool IsApproved { get; set; }
    public System.DateTime CreateDate { get; set; }
    public System.DateTime LastLoginDate { get; set; }
    public System.DateTime LastActivityDate { get; set; }
    public System.DateTime LastPasswordChangedDate { get; set; }
    public string UserName { get; set; }
    public bool IsLockedOut { get; set; }
    public System.DateTime LastLockoutDate { get; set; }
}

public partial class aspnet_Profile_GetProperties_Result
{
    public string PropertyNames { get; set; }
    public string PropertyValuesString { get; set; }
    public byte[] PropertyValuesBinary { get; set; }
}

public partial class aspnet_UsersInRoles_RemoveUsersFromRoles_Result
{
    public string Column1 { get; set; }
    public string Name { get; set; }
}
