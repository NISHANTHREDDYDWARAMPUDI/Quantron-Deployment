pageextension 50071 "Posted Sales Invoice" extends "Posted Sales Invoice"
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