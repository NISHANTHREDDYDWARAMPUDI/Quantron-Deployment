table 50007 "Purch. Rcpt QS Line"
{
    Caption = 'Purchase Receipt Quality Spec Line';
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
        field(4; "Line No."; Integer)
        {
            Caption = 'Line No.';
            DataClassification = ToBeClassified;
        }
        field(5; "Specification Group"; Code[100])
        {
            Caption = 'Specification Group';
            DataClassification = ToBeClassified;
        }
        field(6; Specification; Text[250])
        {
            Caption = 'Specification';
            DataClassification = ToBeClassified;
        }
        field(7; "Value"; Text[150])
        {
            Caption = 'Value';
            DataClassification = ToBeClassified;
        }
        field(8; Check; Boolean)
        {
            Caption = 'Check';
            DataClassification = ToBeClassified;
        }
        field(9; Responsibility; Enum Responsibility)
        {
            Caption = 'Responsibility';
            DataClassification = ToBeClassified;
        }
        field(10; "Document Mandatory"; Boolean)
        {
            Caption = 'Document Mandatory';
            DataClassification = ToBeClassified;
        }
    }
    keys
    {
        key(PK; "Document No.", "Rcpt. Line No.", "Spec ID", "Line No.")
        {
            Clustered = true;
        }
    }
    trigger OnInsert()
    begin
        if PurchRcptQSHdr.Get("Document No.", "Rcpt. Line No.") then
            PurchRcptQSHdr.TestField("Update Status", PurchRcptQSHdr."Update Status"::New);
    end;

    trigger OnModify()
    begin
        if PurchRcptQSHdr.Get("Document No.", "Rcpt. Line No.") then
            PurchRcptQSHdr.TestField("Update Status", PurchRcptQSHdr."Update Status"::New);
    end;

    trigger OnDelete()
    begin
        if PurchRcptQSHdr.Get("Document No.", "Rcpt. Line No.") then
            PurchRcptQSHdr.TestField("Update Status", PurchRcptQSHdr."Update Status"::New);
    end;

    var
        PurchRcptQSHdr: Record "Purch. Rcpt QS Header";
}
