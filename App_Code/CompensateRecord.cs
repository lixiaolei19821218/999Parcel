using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

/// <summary>
/// Summary description for CompensateRecord
/// </summary>
public class CompensateRecord
{
    public int OrderId { get; set; }
    public string TrackNUmber { get; set; }
    public decimal Value { get; set; }
    public DateTime? ApproveTime { get; set; }
}