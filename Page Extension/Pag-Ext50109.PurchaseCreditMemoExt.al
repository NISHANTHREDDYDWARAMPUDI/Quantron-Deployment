pageextension 50109 PurchaseCreditMemoExt extends "Purchase Credit Memo"
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

}