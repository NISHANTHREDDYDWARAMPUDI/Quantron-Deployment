tableextension 50030 ServiceInvHeaderExt extends "Service Invoice Header"
{
    fields
    {
        field(50000; "Shipment Date"; Date)
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
