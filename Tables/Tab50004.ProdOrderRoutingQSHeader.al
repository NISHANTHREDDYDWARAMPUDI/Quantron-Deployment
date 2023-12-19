table 50004 "Prod Ord. Routing QS Header"
{
    Caption = 'Prod Order Routing Quality Spec Header';
    DataClassification = ToBeClassified;
    DataCaptionFields = "Spec ID", Description;

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
        field(7; Description; Text[100])
        {
            Caption = 'Description';
            DataClassification = ToBeClassified;
        }
        field(8; "Update Status"; Option)
        {
            Caption = 'Update Status';
            OptionMembers = New,Posted;
            OptionCaption = 'New,Posted';
            DataClassification = ToBeClassified;
        }
        field(9; "Resource ID"; Code[20])
        {
            Caption = 'Resource ID';
            DataClassification = ToBeClassified;
            TableRelation = Resource;
        }
        field(10; "Time (Hours)"; Decimal)
        {
            Caption = 'Time (Hours)';
            DataClassification = ToBeClassified;
        }
    }
    keys
    {
        key(Key1; Status, "Prod. Order No.", "Routing Reference No.", "Routing No.", "Operation No.", "Spec ID")
        {
            Clustered = true;
        }
    }
    trigger OnModify()
    begin
        TestField("Update Status", Rec."Update Status"::New);
    end;

    trigger OnDelete()
    var
        ProdOrderRoutingQSLine: Record "Prod Ord. Routing QS Line";
    begin
        ProdOrderRoutingQSLine.Reset();
        ProdOrderRoutingQSLine.SetRange(Status, Rec.Status);
        ProdOrderRoutingQSLine.SetRange("Prod. Order No.", Rec."Prod. Order No.");
        ProdOrderRoutingQSLine.SetRange("Routing Reference No.", Rec."Routing Reference No.");
        ProdOrderRoutingQSLine.SetRange("Routing No.", Rec."Routing No.");
        ProdOrderRoutingQSLine.SetRange("Operation No.", Rec."Operation No.");
        ProdOrderRoutingQSLine.SetRange("Spec ID", Rec."Spec ID");
        if ProdOrderRoutingQSLine.FindSet() then
            ProdOrderRoutingQSLine.DeleteAll();
    end;
}

