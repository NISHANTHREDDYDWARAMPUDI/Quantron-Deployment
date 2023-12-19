pageextension 50099 ItemCategoryCardExt extends "Item Category Card"
{
    layout
    {
        addafter("Parent Category")
        {

            field("FG No.Series"; Rec."FG No.Series")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the FG NOSeries field.';
            }
            field(FG; Rec.FG)
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the FG field.';
            }
        }
    }

    actions
    {
        // Add changes to page actions here
    }

    var
        myInt: Integer;
}