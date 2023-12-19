tableextension 50055 PurchInvHeader extends "Purch. Inv. Header"
{
    fields
    {
        field(50000; "PO Mail Sent By"; Code[80])
        {
            Caption = 'PO Mail Sent By';
            Editable = false;
            DataClassification = ToBeClassified;
        }
        field(50001; "PO Mail Sent DateTime"; DateTime)
        {
            Caption = 'PO Mail Sent DateTime';
            Editable = false;
            DataClassification = ToBeClassified;
        }
        field(50003; "PO Mail Status"; Option)
        {
            Caption = 'PO Mail Status';
            Editable = false;
            OptionMembers = " ",Success,Failed;
            OptionCaption = ' ,Success,Failed';
            DataClassification = ToBeClassified;
        }
        field(50004; "PO Mail Error"; Text[500])
        {
            Caption = 'PO Mail Error';
            Editable = false;
            DataClassification = ToBeClassified;
        }
        field(50005; "Document Capturing No."; Code[20])
        {
            Caption = 'Document Capturing No.';
            DataClassification = ToBeClassified;
        }
        field(50006; "Approval Route"; Code[20])
        {
            TableRelation = "Workflow User Group".Code;
            Caption = 'Approval Department';
            DataClassification = ToBeClassified;
        }
    }
}
