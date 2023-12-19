table 50008 "ILE Comment"
{
    Caption = 'Comment';
    DataClassification = ToBeClassified;
    DrillDownPageId = "ILE Comment List";
    LookupPageId = "ILE Comment List";

    fields
    {
        field(1; "Code"; Code[20])
        {
            Caption = 'Code';
            DataClassification = ToBeClassified;
        }
        field(2; Description; Text[50])
        {
            Caption = 'Description';
            DataClassification = ToBeClassified;
        }
    }
    keys
    {
        key(PK; "Code")
        {
            Clustered = true;
        }
    }
}
