pageextension 50094 ServiceOrdersListExt extends "Service Orders"
{
    layout
    {
        // Add changes to page layout here
        addafter(Name)
        {
            field(Description; Rec.Description)
            {
                ApplicationArea = All;
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