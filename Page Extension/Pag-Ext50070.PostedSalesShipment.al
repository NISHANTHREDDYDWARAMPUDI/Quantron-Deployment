pageextension 50070 "Posted Sales Shipment" extends "Posted Sales Shipment"
{
    layout
    {
        addafter("Package Tracking No.")
        {
            field("Total Gross Weight"; Rec."Total Gross Weight")
            {
                ApplicationArea = All;
            }
            field("Total Measurements"; Rec."Total Measurements")
            {
                ApplicationArea = All;
            }
        }
    }
}