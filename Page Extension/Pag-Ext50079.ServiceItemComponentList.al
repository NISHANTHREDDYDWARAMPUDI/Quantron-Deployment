pageextension 50079 ServiceItemComponentList extends "Service Item Component List"
{
    layout
    {
        addafter("Date Installed")
        {
            field("Purchase Recepit Date"; Rec."Purchase Recepit Date")
            {
                ApplicationArea = All;
            }
        }
    }
    actions
    {
        addafter("&Copy from BOM")
        {
            action(Comment)
            {
                ApplicationArea = ItemTracking;
                Caption = 'Comment';
                Image = ViewComments;
                RunObject = Page "Service Item Comp.Trac Comment";
                RunPageLink = Type = CONST("Serial No."),
                                  "Item No." = FIELD("No."),
                                  "Variant Code" = FIELD("Variant Code"),
                                  "Serial/Lot No." = FIELD("Serial No.");
                ToolTip = 'View or add comments for the record.';
            }
        }
    }
}
