pageextension 50075 PostedServiceShipmentLines extends "Posted Service Shipment Lines"
{
    layout
    {
        addafter("Posting Date")
        {
            field("Shipment date"; Rec."Shipment date")
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