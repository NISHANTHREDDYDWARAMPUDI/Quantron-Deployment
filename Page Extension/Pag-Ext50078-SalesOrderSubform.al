pageextension 50078 SaleOrderSubform extends "Sales Order Subform"
{
    layout
    {
        addafter("Location Code")
        {
            field(Inventory; Rec.Inventory)
            {
                ApplicationArea = All;
            }
        }
        addafter(Description)
        {
            field(Revision; Rec.Revision)
            {
                ApplicationArea = All;
            }
        }
    }
}