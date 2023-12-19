pageextension 50074 PostedServiceShipment extends "Posted Service Shipment"
{
    layout
    {
        addafter("Shipment Method")
        {
            field("Shipment date"; Rec."Shipment date")
            {
                ApplicationArea = All;
            }
            field("Package Tracking No"; Rec."Package Tracking No")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Package Tracking No. field.';
            }
        }
    }
}