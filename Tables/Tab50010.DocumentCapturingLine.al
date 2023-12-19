table 50010 "Document Capturing Line"
{
    Caption = 'Document Capturing Line';
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Document No."; Code[20])
        {
            Caption = 'Document No.';
            DataClassification = ToBeClassified;
        }
        field(2; "Line No."; Integer)
        {
            Caption = 'Line No.';
            DataClassification = ToBeClassified;
        }
        field(3; "Product Code"; Code[50])
        {
            Caption = 'Product Code';
            DataClassification = ToBeClassified;
        }
        field(4; Description; Text[2048])
        {
            Caption = 'Description';
            DataClassification = ToBeClassified;
        }
        field(5; "Description 2"; Text[2048])
        {
            Caption = 'Description 2';
            DataClassification = ToBeClassified;
        }
        field(6; "Unit of Measure"; Text[50])
        {
            Caption = 'Unit of Measure';
            DataClassification = ToBeClassified;
        }
        field(7; Quantity; Decimal)
        {
            Caption = 'Quantity';
            DataClassification = ToBeClassified;
        }
        field(8; "VAT %"; Decimal)
        {
            Caption = 'VAT %';
            DataClassification = ToBeClassified;
        }
        field(9; "Line Discount %"; Decimal)
        {
            Caption = 'Line Discount %';
            DataClassification = ToBeClassified;
        }
        field(10; "Line Discount Amount"; Decimal)
        {
            Caption = 'Line Discount Amount';
            DataClassification = ToBeClassified;
        }
        field(11; Amount; Decimal)
        {
            Caption = 'Amount';
            DataClassification = ToBeClassified;
        }
        field(12; "Amount Including VAT"; Decimal)
        {
            Caption = 'Amount Including VAT';
            DataClassification = ToBeClassified;
        }
        field(13; "Currency Code"; Code[10])
        {
            Caption = 'Currency Code';
            DataClassification = ToBeClassified;
        }
        field(14; "Direct Unit Cost"; Decimal)
        {
            Caption = 'Unit Cost';
            DataClassification = ToBeClassified;
        }
        field(15; "Item No."; Code[20])
        {
            Caption = 'Item No';
            DataClassification = ToBeClassified;
        }
        field(16; DocumentID; Guid)
        {
            Caption = 'Document ID';
            DataClassification = ToBeClassified;
            trigger OnValidate()
            var
                DocumentCapturing: Record "Document Capturing Header";
            begin
                if DocumentCapturing.GetBySystemId(DocumentID) then
                    "Document No." := DocumentCapturing."Document No.";
            end;
        }
        field(17; "Base UOM"; Code[10])
        {
            Caption = 'Base Unit of Measure';
            DataClassification = ToBeClassified;
        }
        field(18; Type; Enum "Document Capturing Line Type")
        {
            Caption = 'Type';
        }
        field(19; "No."; Code[20])
        {
            Caption = 'No.';
            TableRelation = IF (Type = CONST(" ")) "Standard Text"
            ELSE
            IF (Type = CONST("G/L Account")) "G/L Account" WHERE("Direct Posting" = CONST(true),
                                                                "Account Type" = CONST(Posting),
                                                                Blocked = CONST(false))
            ELSE
            IF (Type = CONST("Fixed Asset")) "Fixed Asset"
            ELSE
            IF (Type = CONST("Charge (Item)")) "Item Charge"
            ELSE
            IF (Type = CONST(Item)) Item WHERE(Blocked = CONST(false), "Purchasing Blocked" = CONST(false))
            else
            if (Type = const(Resource)) Resource;

            ValidateTableRelation = false;
        }
        field(20; "Gen. Bus. Posting Group"; Code[20])
        {
            Caption = 'Gen. Bus. Posting Group';
            TableRelation = "Gen. Business Posting Group";
        }
        field(21; "Gen. Prod. Posting Group"; Code[20])
        {
            Caption = 'Gen. Prod. Posting Group';
            TableRelation = "Gen. Product Posting Group";
        }
        field(22; "VAT Bus. Posting Group"; Code[20])
        {
            Caption = 'VAT Bus. Posting Group';
            TableRelation = "VAT Business Posting Group";
        }
        field(23; "VAT Prod. Posting Group"; Code[20])
        {
            Caption = 'VAT Prod. Posting Group';
            TableRelation = "VAT Product Posting Group";
        }
        field(28; "Shortcut Dimension 1 Code"; Code[20])
        {
            CaptionClass = '1,2,1';
            Caption = 'Shortcut Dimension 1 Code';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(1),
                                                          Blocked = CONST(false));

        }
        field(29; "Shortcut Dimension 2 Code"; Code[20])
        {
            CaptionClass = '1,2,2';
            Caption = 'Shortcut Dimension 2 Code';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(2),
                                                          Blocked = CONST(false));
        }
    }


    keys
    {
        key(PK; "Document No.", "Line No.")
        {
            Clustered = true;
        }
    }
    trigger OnInsert()
    var
        DocumentCapturingLine: Record "Document Capturing Line";
    begin
        DocumentCapturingLine.Reset();
        DocumentCapturingLine.SetRange("Document No.", Rec."Document No.");
        if DocumentCapturingLine.FindLast() then
            "Line No." := DocumentCapturingLine."Line No." + 10000
        else
            "Line No." := 10000;
        Rec.Type := Rec.Type::"G/L Account";
    end;

    trigger OnModify()
    var
        DocumentCapHdr: Record "Document Capturing Header";
        StatusErr: Label 'Cannot modify data when status is in %1';
    begin
        if not DocumentCapHdr.Get(Rec."Document No.") then
            DocumentCapHdr.Init();
        if (DocumentCapHdr.Status = DocumentCapHdr.Status::Processed) or
            (DocumentCapHdr.Status = DocumentCapHdr.Status::Validated) or
            (DocumentCapHdr.Status = DocumentCapHdr.Status::Rejected) then
            Error(StatusErr, DocumentCapHdr.Status);
    end;
}

