pageextension 50059 ReleasedProdOrderLines extends "Released Prod. Order Lines"
{
    layout
    {
        modify("Location Code")
        {
            Visible = true;
        }
        addafter(Description)
        {
            field(Revision; Rec.Revision)
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Revision field.';
            }
        }
        addlast(Control1)
        {
            field("SO Line No."; Rec."SO Line No.")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Sales Order Line No. field.';
                Visible = false;
            }
        }
    }
    actions
    {
        addafter("Order &Tracking")
        {
            action("Open Service Items")
            {
                ApplicationArea = All;
                Caption = 'Open Service Items';
                Image = ServiceItem;
                RunObject = page "Service Items";
                RunPageLink = "Prod. Order No." = field("Prod. Order No."), "Prod. Order Line No." = field("Line No.");
                RunPageMode = View;
            }
        }
    }
    trigger OnAfterGetRecord()
    var
        ProdOrder: Record "Production Order";
    begin
        ServiceItemsEnable := false;
        if ProdOrder.Get(Rec.Status, Rec."Prod. Order No.") then
            if ProdOrder."Order Type" = ProdOrder."Order Type"::Internal then
                ServiceItemsEnable := true
            else
                ServiceItemsEnable := false;
    end;

    var
        ServiceItemsEnable: Boolean;
}
