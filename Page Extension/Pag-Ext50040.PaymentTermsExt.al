pageextension 50040 PaymentTermsExt extends "Payment Terms"
{
    layout
    {
        addlast(Control1)
        {
            field("Invoice Type"; Rec."Invoice Type")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Invoice Type field.';
            }
        }
        addafter(Description)
        {
            //B2BDNROn10May2023>>
            field("English Description"; Rec."English Description")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies Description in English';
            }
            //B2BDNROn10May2023<<
        }
    }
}
