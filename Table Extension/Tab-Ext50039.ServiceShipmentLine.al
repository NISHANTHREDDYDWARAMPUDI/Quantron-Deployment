tableextension 50039 ServiceShipmentLine extends "Service Shipment Line"
{
    fields
    {
        field(50000; "Shipment date"; Date)
        {
            Caption = 'Shipment Date';
            DataClassification = CustomerContent;
        }
        //QTD-00006>>
        field(50002; "Print On Order"; Boolean)
        {
            Caption = 'Print On Invoice';
            DataClassification = ToBeClassified;
            FieldClass = Normal;
        }
    }
}