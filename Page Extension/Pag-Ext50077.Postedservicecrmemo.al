pageextension 50077 PostedServiceCreditmemo extends "Posted Service Credit Memo"
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