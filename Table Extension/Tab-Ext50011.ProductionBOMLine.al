tableextension 50011 ProductionBOMLine extends "Production BOM Line"
{
    fields
    {
        field(50000; "Description 2"; Text[50])
        {
            Caption = 'Description 2';
            DataClassification = ToBeClassified;
        }
        field(50001; Revision; Code[20])
        {
            Editable = false;
            DataClassification = ToBeClassified;
            Caption = 'Revision';
        }
        field(50002; "Additional Information"; Text[30])
        {
            DataClassification = ToBeClassified;
            Caption = 'Additional Information';
        }

        field(50003; "Level 1 Description"; Text[50])
        {
            Caption = 'Level 1 Description';
            DataClassification = ToBeClassified;
        }
    }
}
