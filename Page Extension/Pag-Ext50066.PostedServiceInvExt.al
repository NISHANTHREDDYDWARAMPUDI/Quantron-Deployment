pageextension 50066 PostedServiceInvExt extends "Posted Service Invoice"
{
    layout
    {
        addafter("Location Code")
        {
            field("Package Tracking No"; Rec."Package Tracking No")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Package Tracking No. field.';
            }
            field("Shipment Date"; Rec."Shipment Date")
            {
                ApplicationArea = All;

            }
        }
    }
}
