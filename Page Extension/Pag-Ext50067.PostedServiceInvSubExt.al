pageextension 50067 PostedServiceInvSubExt extends "Posted Service Invoice Subform"
{
    layout
    {
        addafter("Variant Code")
        {

            field("Shipment Date"; Rec."Shipment Date")
            {
                ApplicationArea = All;
            }
        }
        //QTD-00006>>
        addafter(Quantity)
        {
            field("Print On Order"; Rec."Print On Order")
            {
                ApplicationArea = All;
            }
        }
        //QTD-00006<<
    }
}
