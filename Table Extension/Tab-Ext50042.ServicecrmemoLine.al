tableextension 50042 ServiceCrmemoLine extends "Service Cr.Memo Line"
{
    fields
    {
        field(50000; "Shipment Date"; Date)
        {
            Caption = 'Shipment Date';
            DataClassification = CustomerContent;
        }
    }
}
