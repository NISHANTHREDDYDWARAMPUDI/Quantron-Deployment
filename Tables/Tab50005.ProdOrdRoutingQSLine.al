table 50005 "Prod Ord. Routing QS Line"
{
    Caption = 'Prod Ord. Routing Quality Spec Line';
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Routing No."; Code[20])
        {
            Caption = 'Routing No.';
            NotBlank = true;
            TableRelation = "Routing Header";
        }
        field(2; "Operation No."; Code[10])
        {
            Caption = 'Operation No.';
            TableRelation = "Prod. Order Routing Line"."Operation No." WHERE(Status = FIELD(Status),
                                                                              "Prod. Order No." = FIELD("Prod. Order No."),
                                                                              "Routing No." = FIELD("Routing No."));
        }
        field(3; Status; Enum "Production Order Status")
        {
            Caption = 'Status';
        }
        field(4; "Prod. Order No."; Code[20])
        {
            Caption = 'Prod. Order No.';
            NotBlank = true;
            TableRelation = "Production Order"."No." WHERE(Status = FIELD(Status));
        }
        field(5; "Routing Reference No."; Integer)
        {
            Caption = 'Routing Reference No.';
            TableRelation = "Prod. Order Routing Line"."Routing Reference No." WHERE("Routing No." = FIELD("Routing No."),
                                                                                      "Operation No." = FIELD("Operation No."),
                                                                                      "Prod. Order No." = FIELD("Prod. Order No."),
                                                                                      Status = FIELD(Status));
            //This property is currently not supported
            //TestTableRelation = false;
            ValidateTableRelation = false;
        }
        field(6; "Spec ID"; Code[20])
        {
            Caption = 'Spec ID';
            DataClassification = ToBeClassified;
        }
        field(7; "Line No."; Integer)
        {
            Caption = 'Line No.';
            DataClassification = ToBeClassified;
        }
        field(8; "Specification Group"; Code[100])
        {
            Caption = 'Specification Group';
            DataClassification = ToBeClassified;
        }
        field(9; Specification; Text[250])
        {
            Caption = 'Specification';
            DataClassification = ToBeClassified;
        }
        field(10; "Value"; Text[150])
        {
            Caption = 'Value';
            DataClassification = ToBeClassified;
        }
        field(11; Check; Boolean)
        {
            Caption = 'Check';
            DataClassification = ToBeClassified;
        }
        field(12; Responsibility; Enum Responsibility)
        {
            Caption = 'Responsibility';
            DataClassification = ToBeClassified;
        }
        field(13; "Document Mandatory"; Boolean)
        {
            Caption = 'Document Mandatory';
            DataClassification = ToBeClassified;
        }
    }
    keys
    {
        key(Key1; Status, "Prod. Order No.", "Routing Reference No.", "Routing No.", "Operation No.", "Spec ID", "Line No.")
        {
            Clustered = true;
        }
    }

    trigger OnInsert()
    begin
        if ProdOrderRoutingQSHdr.Get(Status, "Prod. Order No.", "Routing Reference No.", "Routing No.", "Operation No.", "Spec ID") then
            ProdOrderRoutingQSHdr.TestField("Update Status", ProdOrderRoutingQSHdr."Update Status"::New);
    end;

    trigger OnModify()
    begin
        if ProdOrderRoutingQSHdr.Get(Status, "Prod. Order No.", "Routing Reference No.", "Routing No.", "Operation No.", "Spec ID") then
            ProdOrderRoutingQSHdr.TestField("Update Status", ProdOrderRoutingQSHdr."Update Status"::New);
    end;

    trigger OnDelete()
    begin
        if ProdOrderRoutingQSHdr.Get(Status, "Prod. Order No.", "Routing Reference No.", "Routing No.", "Operation No.", "Spec ID") then
            ProdOrderRoutingQSHdr.TestField("Update Status", ProdOrderRoutingQSHdr."Update Status"::New);
    end;

    var
        ProdOrderRoutingQSHdr: Record "Prod Ord. Routing QS Header";
}
