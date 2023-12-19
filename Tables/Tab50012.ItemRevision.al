table 50012 "Item Revision"
{
    Caption = 'Item Revision';
    DataClassification = ToBeClassified;
    DrillDownPageId = "Item Revision";
    LookupPageId = "Item Revision";
    fields
    {
        field(1; "Item No."; Code[20])
        {
            Caption = 'Item No.';
        }
        field(2; "Revision"; Code[20])
        {
            Caption = 'Revision ';
        }
        field(3; "Item Description"; Text[100])
        {
            Caption = 'Description';
        }
    }
    keys
    {
        key(PK; "Item No.", "Revision")
        {
            Clustered = true;
        }
    }
}
