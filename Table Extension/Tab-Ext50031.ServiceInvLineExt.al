tableextension 50031 ServiceInvLineExt extends "Service Invoice Line"
{
    fields
    {
        field(50000; "Shipment Date"; Date)
        {
            Caption = 'Shipment Date';
            DataClassification = CustomerContent;
        }
        //QTD-00006>>
        field(50002; "Print On Order"; Boolean)
        {
            Caption = 'Print On Invoice';
            DataClassification = ToBeClassified;
        }
        //QTD-00006<<

    }
}
