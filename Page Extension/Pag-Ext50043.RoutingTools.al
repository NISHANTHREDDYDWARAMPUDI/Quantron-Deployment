pageextension 50043 RoutingTools extends "Routing Tools"
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
