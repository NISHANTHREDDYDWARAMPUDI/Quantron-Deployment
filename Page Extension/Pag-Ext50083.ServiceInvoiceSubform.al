pageextension 50083 ServiceInvoiceSubform extends "Service Invoice Subform"
{
    layout
    {
        // Add changes to page layout here
        addafter(Quantity)
        {
            //QTD-00006>>
            //CHB2B14Nov2023<<
            // field("Print On Order"; Rec."Print On Order")
            // {
            //     ApplicationArea = All;
            // }

            //QTD-00006>>//CHB2B14Nov2023>>
        }
    }

    actions
    {
        // Add changes to page actions here
    }

    var
        myInt: Integer;
}