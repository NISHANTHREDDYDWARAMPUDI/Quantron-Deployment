pageextension 50098 PurchaseInvoice extends "Purchase Invoice"
{
    layout
    {
        addlast(General)
        {
            field("Approval Route"; Rec."Approval Route")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Approval Route field.';
            }
        }
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
