tableextension 50012 "Purchases&PayablesSetup" extends "Purchases & Payables Setup"
{
    fields
    {
        field(50000; "Purch./LogisticsTeam E-Mail"; Text[500])
        {
            Caption = 'Purchase/LogisticsTeam E-Mail';
            DataClassification = ToBeClassified;
        }
        field(50001; "Purch./LogisticsTeam E-Mail CC"; Text[500])
        {
            Caption = 'Purchase/LogisticsTeam E-Mail CC';
            DataClassification = ToBeClassified;
        }
        field(50002; "Project Team E-Mail"; Text[500])
        {
            Caption = 'Project Team E-Mail';
            DataClassification = ToBeClassified;
        }
        field(50003; "Project Team E-Mail CC"; Text[500])
        {
            Caption = 'Project Team E-Mail CC';
            DataClassification = ToBeClassified;
        }
        field(50004; "Reclass Journal Template"; Code[20])
        {
            Caption = 'Reclass Journal Template';
            DataClassification = ToBeClassified;
            TableRelation = "Item Journal Template".Name where(Type = const(Transfer));
        }
        field(50005; "Reclass Journal Batch"; Code[20])
        {
            Caption = 'Reclass Journal Batch';
            DataClassification = ToBeClassified;
            TableRelation = "Item Journal Batch".Name where("Journal Template Name" = field("Reclass Journal Template"));
        }
        field(50006; "Def. Phy. Inv Template"; code[10])
        {
            Caption = 'Default Physical Inventory Template';
            DataClassification = ToBeClassified;
            TableRelation = "Item Journal Template".Name;
        }
        field(50007; "Def. Phy. Inv Batch"; code[10])
        {
            Caption = 'Default Physical Inventory Batch';
            DataClassification = ToBeClassified;
            TableRelation = "Item Journal Batch".Name where("Journal Template Name" = field("Def. Phy. Inv Template"));
        }
        field(50008; "Phy. Inv Logistic Email"; Text[250])
        {
            Caption = 'Physical Inventory Logistic Email';
            DataClassification = ToBeClassified;
        }
        field(50009; "Document Capturing No."; Code[20])
        {
            Caption = 'Document Capturing No.';
            TableRelation = "No. Series";
        }
        field(50010; "Document Capturing Email"; Text[250])
        {
            Caption = 'Document Capturing Error log Email';
            DataClassification = ToBeClassified;
        }
        field(50011; "Quality Check Incoming Email"; Text[250])
        {
            Caption = 'Quality Check Incoming Email';
            DataClassification = ToBeClassified;
        }
    }
}
