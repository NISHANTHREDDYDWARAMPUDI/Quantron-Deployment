pageextension 50048 ProductionBOMLine extends "Production BOM Lines"
{
    layout
    {
        addafter(Description)
        {
            field("Description 2"; Rec."Description 2")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Description 2 field.';
            }
            field(Revision; Rec.Revision)
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Revision field.';
            }
            field("Additional Information"; Rec."Additional Information")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Additional Information field.';
            }

            field("Level 1 Description"; Rec."Level 1 Description")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Level 1 Description field.';
            }
        }
    }
}
