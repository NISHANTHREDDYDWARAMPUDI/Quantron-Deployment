pageextension 50073 "Sales Order Archive" extends "Sales Order Archive"
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