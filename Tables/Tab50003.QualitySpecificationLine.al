table 50003 "Quality Specification Line"
{
    Caption = 'Quality Specification Line';
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Spec ID"; Code[20])
        {
            Caption = 'Spec ID';
            DataClassification = ToBeClassified;
        }
        field(2; "Line No."; Integer)
        {
            Caption = 'Line No.';
            DataClassification = ToBeClassified;
        }
        field(3; "Specification Group"; Code[100])
        {
            Caption = 'Specification Group';
            DataClassification = ToBeClassified;
        }
        field(4; Specification; Text[250])
        {
            Caption = 'Specification';
            DataClassification = ToBeClassified;
        }
        field(5; Responsibility; Enum Responsibility)
        {
            Caption = 'Responsibility';
            DataClassification = ToBeClassified;
        }
        field(6; "Document Mandatory"; Boolean)
        {
            Caption = 'Document Mandatory';
            DataClassification = ToBeClassified;
        }
    }
    keys
    {
        key(PK; "Spec ID", "Line No.")
        {
            Clustered = true;
        }
    }
}
