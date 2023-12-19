pageextension 50072 "Posted Sales Cr Memo" extends "Posted Sales Credit Memo"
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