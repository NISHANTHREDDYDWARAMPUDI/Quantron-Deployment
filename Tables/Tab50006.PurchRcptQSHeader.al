table 50006 "Purch. Rcpt QS Header"
{
    Caption = 'Purchase Receipt Quality Spec Header';
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Document No."; Code[20])
        {
            Caption = 'Document No.';
            DataClassification = ToBeClassified;
        }
        field(2; "Rcpt. Line No."; Integer)
        {
            Caption = 'Rcpt. Line No.';
            DataClassification = ToBeClassified;
        }
        field(3; "Spec ID"; Code[20])
        {
            Caption = 'Spec ID';
            DataClassification = ToBeClassified;
        }
        field(4; Description; Text[100])
        {
            Caption = 'Description';
            DataClassification = ToBeClassified;
        }
        field(5; "Update Status"; Option)
        {
            Caption = 'Update Status';
            OptionMembers = New,Posted;
            OptionCaption = 'New,Posted';
            DataClassification = ToBeClassified;
        }
        field(6; "Resource ID"; Code[20])
        {
            Caption = 'Resource ID';
            DataClassification = ToBeClassified;
            TableRelation = Resource;
        }
        field(7; "Time (Hours)"; Decimal)
        {
            Caption = 'Time (Hours)';
            DataClassification = ToBeClassified;
        }
    }
    keys
    {
        key(PK; "Document No.", "Rcpt. Line No.", "Spec ID")
        {
            Clustered = true;
        }
    }
}
