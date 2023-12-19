pageextension 50047 ProductionBOM extends "Production BOM"
{
    layout
    {
        addafter(Description)
        {
            field("Description 2"; Rec."Description 2")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies an extended description for the BOM if there is not enough space in the Description field.';
            }
        }
    }
}
