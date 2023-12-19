pageextension 50042 RoutingLines extends "Routing Lines"
{
    layout
    {
        addafter(Description)
        {
            field("Work Instruction"; Rec."Work Instruction")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Work Instruction field.';
            }
            field("Quality Check"; Rec."Quality Check")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Quality Check field.';
            }
            field("Quality Spec ID"; Rec."Quality Spec ID")
            {
                Editable = Rec."Quality Check";
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Quality Spec ID field.';
            }
        }
    }
}
