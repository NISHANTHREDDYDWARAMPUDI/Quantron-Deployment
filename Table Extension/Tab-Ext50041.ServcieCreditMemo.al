tableextension 50041 ServiceCreditmemoHeader extends "Service Cr.Memo Header"
{
    fields
    {
        field(50000; "Shipment date"; Date)
        {
            Caption = 'Shipment Date';
            DataClassification = CustomerContent;
        }
        field(50002; "Package Tracking No"; Text[30])
        {
            Caption = 'Package Tracking No.';
        }
    }
}