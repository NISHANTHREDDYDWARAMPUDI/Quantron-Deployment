pageextension 50045 ProdOrderRoutingTools extends "Prod. Order Routing Tools"
{
    layout
    {
        addbefore("No.")
        {
            field("Type"; Rec."Type")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Type field.';
            }
        }
    }
}
