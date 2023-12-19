pageextension 50110 PurchaseReturnOrderExt extends "Purchase Return Order"
{
    layout
    {

        addafter("Order Address Code")
        {

            field("VAT Registration No."; Rec."VAT Registration No.")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the VAT Registration No. field.';
                Editable = false;
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