pageextension 50081 StockkeepingUnitList extends "Stockkeeping Unit List"
{
    layout
    {
        moveafter(Inventory; "Replenishment System")
        addafter(Description)
        {
            field(Description2; Rec."Description 2")
            {
                ApplicationArea = All;
            }
        }
        addafter(Inventory)
        {
            field("Qty. on Purch. Order"; Rec."Qty. on Purch. Order")
            {
                ApplicationArea = All;
            }
            field("Qty. on Sales Order"; Rec."Qty. on Sales Order")
            {
                ApplicationArea = All;
            }
            field("Last Direct Cost"; Rec."Last Direct Cost")
            {
                ApplicationArea = All;
            }
        }
        modify("Variant Code")
        {
            Visible = false;
        }
        moveafter(Description2; "Location Code")
        modify("Replenishment System")
        {
            Visible = false;
        }
    }
}
