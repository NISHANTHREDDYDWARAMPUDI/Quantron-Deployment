table 50009 "Document Capturing Header"
{
    Caption = 'Document Capturing';
    DataClassification = ToBeClassified;
    LookupPageId = "Document Capturing List";
    DrillDownPageId = "Document Capturing List";
    fields
    {
        field(1; "Document No."; Code[20])
        {
            Caption = 'Document No.';
            DataClassification = ToBeClassified;
        }
        field(2; "Purchase Order No."; Code[50])
        {
            Caption = 'Purchase Order No.';
            DataClassification = ToBeClassified;
        }
        field(3; "Buy-from Vendor No."; Code[20])
        {
            Caption = 'Vendor No.';
            DataClassification = ToBeClassified;
            TableRelation = Vendor."No.";
        }
        field(4; "Customer Tax ID"; Text[150])
        {
            Caption = 'Customer Tax ID';
            DataClassification = ToBeClassified;
        }
        field(5; "Order Date"; Date)
        {
            Caption = 'Order Date';
            DataClassification = ToBeClassified;
        }
        field(6; "Posting Date"; Date)
        {
            Caption = 'Posting Date';
            DataClassification = ToBeClassified;
        }
        field(7; "Payment Terms"; Text[250])
        {
            Caption = 'Payment Terms';
            DataClassification = ToBeClassified;
        }
        field(8; "Due Date"; Date)
        {
            Caption = 'Due Date';
            DataClassification = ToBeClassified;
        }
        field(9; "Location Code"; Text[100])
        {
            Caption = 'Location Code';
            DataClassification = ToBeClassified;
        }
        field(10; "Currency Code"; Text[100])
        {
            Caption = 'Currency Code';
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
        field(13; "Vendor Invoice No."; Text[35])
        {
            Caption = 'Vendor Invoice No.';
            DataClassification = ToBeClassified;
        }
        field(14; "VAT Registration No."; Text[50])
        {
            Caption = 'Vendor VAT Registration No.';
            DataClassification = ToBeClassified;
        }
        field(15; "Customer ID"; Text[150])
        {
            Caption = 'Customer ID';
            DataClassification = ToBeClassified;
        }
        field(16; "Vendor Name"; Text[250])
        {
            Caption = 'Vendor Name';
            DataClassification = ToBeClassified;
        }
        field(17; "Vendor Address"; Text[1048])
        {
            Caption = 'Vendor Address';
            DataClassification = ToBeClassified;
        }
        field(18; "Document Date"; Date)
        {
            Caption = 'Document Date';
            DataClassification = ToBeClassified;
        }
        field(19; Posted; Boolean)
        {
            Caption = 'Posted';
            DataClassification = ToBeClassified;
        }
        field(20; Status; Option)
        {
            Caption = 'Status';
            Editable = false;
            OptionCaption = 'New,Validated,Invoice Created,Failed,Rejected,Verified,PO Invoice';
            OptionMembers = New,Validated,Processed,Failed,Rejected,Verified,"PO Invoice";
        }
        field(21; "ERP Document No."; Code[20])
        {
            Caption = 'ERP Document No.';
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(22; "Customer Name"; Text[150])
        {
            Caption = 'Customer Name';
            DataClassification = ToBeClassified;
        }
        field(23; "Customer Address"; Text[500])
        {
            Caption = 'Customer Address';
            DataClassification = ToBeClassified;
        }
        field(24; "VAT Amount"; Decimal)
        {
            Caption = 'VAT Amount';
            DataClassification = ToBeClassified;
        }
        field(25; "No. Series"; Code[20])
        {
            Caption = 'No. Series';
            Editable = false;
            TableRelation = "No. Series";
        }
        field(26; Attachment; BLOB)
        {
            Caption = 'Attachment';
            DataClassification = SystemMetadata;
            SubType = Bitmap;
        }
        field(27; "File Name"; Text[500])
        {
            Caption = 'File Name';
            DataClassification = ToBeClassified;
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
        field(40; "Last Status Change Date"; Date)
        {
            Caption = 'Last Status Change Date';
            Editable = false;
        }
        field(41; "Approval Status"; Option)
        {
            OptionMembers = Open,Released,"Pending Approval",Declined;
            OptionCaption = 'Open,Released,Pending Approval,Declined';
            DataClassification = ToBeClassified;
        }
        field(42; "Approval Route"; Code[20])
        {
            TableRelation = "Workflow User Group".Code;
            Caption = 'Approval Department';
            DataClassification = ToBeClassified;
        }
        field(43; "ERP Posted Document No."; Code[20])
        {
            Caption = 'ERP Posted Document No.';
            DataClassification = ToBeClassified;
        }
    }
    keys
    {
        key(PK; "Document No.")
        {
            Clustered = true;
        }
    }

    var
        DocumentCapturingLine: Record "Document Capturing Line";
        ErrorMessage: Record "Error Message";
        TempErrorMessage: Record "Error Message" temporary;
        StatusMessageMsg: Label 'Document has been moved to status %1';
        SendToVerified: Boolean;

    trigger OnInsert()
    var
        PurchSetup: Record "Purchases & Payables Setup";
        NoSeriesMgt: Codeunit NoSeriesManagement;
        PONoTxt: Text[50];
    begin
        if "Document No." = '' then begin
            PurchSetup.Get();
            PurchSetup.TestField("Document Capturing No.");
            NoSeriesMgt.InitSeries(PurchSetup."Document Capturing No.", xRec."No. Series", 0D, "Document No.", "No. Series");
        end;
        PONoTxt := Rec."Purchase Order No.";
        if PONoTxt.Contains('EB') then
            Rec.Status := Rec.Status::"PO Invoice";
        "Last Status Change Date" := WorkDate();
    end;

    trigger OnDelete()
    var
        DocumentAttach: Record "Document Attachment";
    begin
        DocumentCapturingLine.Reset();
        DocumentCapturingLine.SetRange("Document No.", Rec."Document No.");
        if DocumentCapturingLine.FindSet() then
            DocumentCapturingLine.DeleteAll();

        ErrorMessage.Reset();
        ErrorMessage.SetRange("Context Record ID", RecordId);
        if ErrorMessage.FindSet() then
            ErrorMessage.DeleteAll();

        DocumentAttach.Reset();
        DocumentAttach.SetRange("No.", Rec."Document No.");
        if DocumentAttach.FindSet() then
            DocumentAttach.DeleteAll();
    end;

    trigger OnModify()
    var
        StatusErr: Label 'Cannot modify data when status is in %1';
    begin
        if (xRec.Status = xRec.Status::Processed) and (Rec.Status = Rec.Status::Processed) or
            (xRec.Status = xRec.Status::Validated) and (Rec.Status = Rec.Status::Validated) or
            (xRec.Status = xRec.Status::Rejected) and (Rec.Status = Rec.Status::Rejected) then
            Error(StatusErr, Rec.Status);
    end;

    procedure CreateDoc()
    var
        DuplicateDocErr: Label 'Purchase invoice is already created with invoice no. %1.';
    begin
        if Rec."ERP Document No." <> '' then
            Error(DuplicateDocErr, Rec."ERP Document No.");
        CreatePurchDoc();
        if GuiAllowed then
            ShowResultMessage(ErrorMessage);
    end;

    procedure VerifyAttachmentData()
    var
        CompanyInfo: Record "Company Information";
        PurchInvHdr: Record "Purch. Inv. Header";
        PurchHdr: Record "Purchase Header";
        UOMRec: Record "Unit of Measure";
        VendorLRec: Record Vendor;
        CountryRec: Record "Country/Region";
        VendorRec: Record Vendor;
        UOMNo: Code[10];
        ItemNo: Code[20];
        VendorNo: Code[20];
        UpdateLineData: Boolean;
        CustomerInvalidErr: Label 'Customer name is not a valid name.';
        CustomerTaxIDErr: Label 'Customer tax id is invalid.';
        DuplicateDocErr: Label 'Purchase invoice is already created with invoice no. %1.';
        DuplicatePostedDocErr: Label 'Invoice is already posted with posted invoice no. %1 with vendor invoice no. %2.';
        HeaderAmountMismatch: Label 'Amount plus Vat Amount is not equals to Amount Inc.Vat. Please check line amounts whether all captured correctly, if not adjust manually and validate.';
        ItemMissLbl: Label 'Item master cannot be found for the line no. %1.';
        UOMInvalidErr: Label 'Unit of measure is invalid for the line no. %1';
        NoLinesFoundErr: Label 'No Lines Found';
        AddressErr: Label 'Customer address %1 does not contains the company information address %2.';
        CityErr: Label 'Customer address %1 does not contains the company information city %2.';
        PostCodeErr: Label 'Customer address %1 does not contains the company information postcode %2.';
        CountryErr: Label 'Customer address %1 does not contains the company information country %2.';
        CustomerAddMissingErr: Label 'Customer address is missing.';
        TotalAmount: Decimal;
        DocAmountMismatch: Label 'sum of line amounts and header total amount are not equal, may be discount or tax% or amount for some lines has not captured. Please adjust manually and validate.';
        CompanyAddress: Text;
        VendorInvNoBlank: Label 'Vendor Invoice No. is blank';
        VendorMissLbl: Label 'Vendor master cannot be found with vendor name, address and VAT registration no.';
    begin
        Clear(TotalAmount);
        Clear(SendToVerified);
        ClearErrorMessages();
        ErrorMessage.SetContext(Rec);

        if Rec."ERP Document No." <> '' then
            ErrorMessage.LogSimpleMessage(ErrorMessage."Message Type"::Error, StrSubstNo(DuplicateDocErr, Rec."ERP Document No."));

        CompanyInfo.Get();
        if not LowerCase(Rec."Customer Name").Contains(LowerCase(CompanyInfo.Name)) then
            ErrorMessage.LogSimpleMessage(ErrorMessage."Message Type"::Error, CustomerInvalidErr);

        if Rec."Customer Tax ID" <> '' then
            if Rec."Customer Tax ID".Contains('DE') then
                if DelChr(Rec."Customer Tax ID", '=', ' ,./\|{]}') <> CompanyInfo."VAT Registration No." then
                    ErrorMessage.LogSimpleMessage(ErrorMessage."Message Type"::Error, CustomerTaxIDErr);

        if "Customer Address" <> '' then begin
            CompanyAddress := LowerCase(Rec."Customer Address");
            if not CompanyAddress.Contains(LowerCase(CompanyInfo.City)) then
                ErrorMessage.LogSimpleMessage(ErrorMessage."Message Type"::Error, StrSubstNo(CityErr, "Customer Address", CompanyInfo.City));
            if not CompanyAddress.Contains(LowerCase(CompanyInfo."Post Code")) then
                ErrorMessage.LogSimpleMessage(ErrorMessage."Message Type"::Error, StrSubstNo(PostCodeErr, "Customer Address", CompanyInfo."Post Code"));
        end else
            ErrorMessage.LogSimpleMessage(ErrorMessage."Message Type"::Error, CustomerAddMissingErr);

        if Rec."VAT Registration No." <> '' then
            VendorNo := GetVendorNoByVATRegNo(DelChr(Rec."VAT Registration No.", '=', ' ,./\|{]}'));
        if VendorNo = '' then
            VendorNo := GetVendorNoByNameAddr(CopyStr(Rec."Vendor Name", 1, 100), CopyStr(Rec."Vendor Address", 1, 100), DelChr(Rec."VAT Registration No.", '=', ' ,./\|{]}'));
        if VendorRec.Get(VendorNo) then
            Rec."Buy-from Vendor No." := VendorNo
        else
            if not SendToVerified then
                ErrorMessage.LogSimpleMessage(ErrorMessage."Message Type"::Error, VendorMissLbl);


        if Rec."Vendor Invoice No." = '' then
            ErrorMessage.LogSimpleMessage(ErrorMessage."Message Type"::Warning, VendorInvNoBlank);

        PurchHdr.Reset();
        PurchHdr.SetRange("Vendor Invoice No.", Rec."Vendor Invoice No.");
        if PurchHdr.FindFirst() and (Rec."Vendor Invoice No." <> '') then
            ErrorMessage.LogSimpleMessage(ErrorMessage."Message Type"::Error, StrSubstNo(DuplicateDocErr, PurchHdr."No."));

        PurchInvHdr.Reset();
        PurchInvHdr.SetRange("Vendor Invoice No.", Rec."Vendor Invoice No.");
        if PurchInvHdr.FindFirst() and (Rec."Vendor Invoice No." <> '') then
            ErrorMessage.LogSimpleMessage(ErrorMessage."Message Type"::Error, StrSubstNo(DuplicatePostedDocErr, PurchInvHdr."No.", PurchInvHdr."Vendor Invoice No."));

        if not HasValidValue(Rec."Document Date") then
            ErrorMessage.LogSimpleMessage(ErrorMessage."Message Type"::Error, GetLastErrorText());

        if not HasValidValue(Rec.Amount) then
            ErrorMessage.LogSimpleMessage(ErrorMessage."Message Type"::Error, GetLastErrorText());

        if not HasValidValue(Rec."VAT Amount") then
            ErrorMessage.LogSimpleMessage(ErrorMessage."Message Type"::Error, GetLastErrorText());

        if not HasValidValue(Rec."Amount Including VAT") then
            ErrorMessage.LogSimpleMessage(ErrorMessage."Message Type"::Error, GetLastErrorText());

        if (Rec.Amount <> 0) and (Rec."Amount Including VAT" <> 0) then
            if Rec.Amount + Rec."VAT Amount" <> Rec."Amount Including VAT" then
                ErrorMessage.LogSimpleMessage(ErrorMessage."Message Type"::Warning, HeaderAmountMismatch);

        DocumentCapturingLine.Reset();
        DocumentCapturingLine.SetRange("Document No.", Rec."Document No.");
        if not DocumentCapturingLine.FindSet() then
            ErrorMessage.LogSimpleMessage(ErrorMessage."Message Type"::Error, NoLinesFoundErr)
        else begin
            DocumentCapturingLine.CalcSums(Amount);
            TotalAmount += DocumentCapturingLine.Amount;
        end;

        if (TotalAmount <> Rec.Amount) and (TotalAmount <> Rec."Amount Including VAT") then
            ErrorMessage.LogSimpleMessage(ErrorMessage."Message Type"::Warning, DocAmountMismatch);


        ErrorMessage.Reset();
        ErrorMessage.SetRange("Context Record ID", Rec.RecordId);
        ErrorMessage.SetRange("Message Type", ErrorMessage."Message Type"::Error);
        if ErrorMessage.Count > 0 then
            Rec.Status := Rec.Status::Failed
        else
            Rec.Status := Rec.Status::Verified;

        DocumentCapturingLine.Reset();
        DocumentCapturingLine.SetRange("Document No.", Rec."Document No.");
        if DocumentCapturingLine.IsEmpty() then
            Rec.Status := Rec.Status::Rejected;

        PurchHdr.Reset();
        PurchHdr.SetRange("Vendor Invoice No.", Rec."Vendor Invoice No.");
        if PurchHdr.FindFirst() and (Rec."Vendor Invoice No." <> '') then
            Rec.Status := Rec.Status::Rejected;

        PurchInvHdr.Reset();
        PurchInvHdr.SetRange("Vendor Invoice No.", Rec."Vendor Invoice No.");
        if PurchInvHdr.FindFirst() and (Rec."Vendor Invoice No." <> '') then
            Rec.Status := Rec.Status::Rejected;
        Rec."Last Status Change Date" := WorkDate();
        if GuiAllowed then
            Message(StatusMessageMsg, Rec.Status);
    end;

    procedure ValidateData()
    var
        TypeBlankErr: Label 'Type is comment so quantity and amount should be zero for line %1';
        NoBlankErr: Label 'No. is blank for line %1';
        QuantityZeroErr: Label 'Quantity is blank for line %1';
        AmountZeroErr: Label 'Amount is blank for line %1';
    begin
        ClearErrorMessages();
        ErrorMessage.SetContext(Rec);

        DocumentCapturingLine.Reset();
        DocumentCapturingLine.SetRange("Document No.", Rec."Document No.");
        if DocumentCapturingLine.FindSet() then
            repeat
                case true of
                    (DocumentCapturingLine.Type = DocumentCapturingLine.Type::" ") and ((DocumentCapturingLine.Quantity <> 0) or (DocumentCapturingLine.Amount <> 0)):
                        ErrorMessage.LogSimpleMessage(ErrorMessage."Message Type"::Error, StrSubstNo(TypeBlankErr, DocumentCapturingLine."Line No."));
                    (DocumentCapturingLine."No." = '') and (DocumentCapturingLine.Quantity <> 0):
                        ErrorMessage.LogSimpleMessage(ErrorMessage."Message Type"::Error, StrSubstNo(NoBlankErr, DocumentCapturingLine."Line No."));
                    (DocumentCapturingLine.Type <> DocumentCapturingLine.Type::" ") and (DocumentCapturingLine.Quantity = 0):
                        ErrorMessage.LogSimpleMessage(ErrorMessage."Message Type"::Error, StrSubstNo(QuantityZeroErr, DocumentCapturingLine."Line No."));
                    (DocumentCapturingLine.Type <> DocumentCapturingLine.Type::" ") and (DocumentCapturingLine.Amount = 0):
                        ErrorMessage.LogSimpleMessage(ErrorMessage."Message Type"::Error, StrSubstNo(AmountZeroErr, DocumentCapturingLine."Line No."));
                end;
            until DocumentCapturingLine.Next() = 0;

        ErrorMessage.Reset();
        ErrorMessage.SetRange("Context Record ID", Rec.RecordId);
        ErrorMessage.SetRange("Message Type", ErrorMessage."Message Type"::Error);
        if ErrorMessage.Count > 0 then
            Rec.Status := Rec.Status::Failed
        else
            Rec.Status := Rec.Status::Validated;
        Rec."Last Status Change Date" := WorkDate();
        if GuiAllowed then
            Message(StatusMessageMsg, Rec.Status);
    end;

    procedure ViewInPdfViewer(Popup: Boolean)
    var
        OpenPdfViewerMeth: Codeunit OpenPdfViewerMeth;
    begin
        OpenPdfViewerMeth.OpenPdfViewer(Rec, Rec.FieldNo(Attachment), Popup);
    end;

    local procedure ClearErrorMessages()
    var
        ErrorMessage: Record "Error Message";
    begin
        ErrorMessage.SetRange("Context Record ID", RecordId);
        ErrorMessage.DeleteAll();
        TempErrorMessage.SetRange("Context Record ID", RecordId);
        TempErrorMessage.DeleteAll();
    end;

    local procedure CreatePurchDoc()
    var
        PurchHeader, PurchHeader2 : Record "Purchase Header";
        PurchLine: Record "Purchase Line";
        LineNo: integer;
        LineDimensionBlank: Boolean;
    begin
        PurchHeader.Reset();
        PurchHeader.Init();
        PurchHeader."Document Type" := PurchHeader."Document Type"::Invoice;
        PurchHeader."No." := '';
        PurchHeader.Insert(true);
        PurchHeader.Validate("Buy-from Vendor No.", Rec."Buy-from Vendor No.");
        PurchHeader."Vendor Invoice No." := Rec."Vendor Invoice No.";
        PurchHeader.Validate("Document Date", Rec."Document Date");
        PurchHeader."Document Capturing No." := "Document No.";
        if "Shortcut Dimension 1 Code" <> '' then
            PurchHeader.Validate("Shortcut Dimension 1 Code", Rec."Shortcut Dimension 1 Code");
        if "Shortcut Dimension 2 Code" <> '' then
            PurchHeader.Validate("Shortcut Dimension 2 Code", Rec."Shortcut Dimension 2 Code");

        DocumentCapturingLine.Reset();
        DocumentCapturingLine.SetRange("Document No.", Rec."Document No.");
        DocumentCapturingLine.SetRange("Shortcut Dimension 1 Code", '');
        DocumentCapturingLine.SetRange("Shortcut Dimension 2 Code", '');
        DocumentCapturingLine.SetFilter(Type, '<>%1', DocumentCapturingLine.Type::" ");
        if DocumentCapturingLine.FindFirst() then
            LineDimensionBlank := true;

        if ("Shortcut Dimension 1 Code" = '') and ("Shortcut Dimension 2 Code" = '') and (LineDimensionBlank) then
            PurchHeader.Validate("Shortcut Dimension 1 Code", '111');
        PurchHeader.Modify(true);
        Rec."ERP Document No." := PurchHeader."No.";

        DocumentCapturingLine.Reset();
        DocumentCapturingLine.SetRange("Document No.", Rec."Document No.");
        if DocumentCapturingLine.FindSet() then
            repeat
                LineNo += 10000;
                PurchLine.Reset();
                PurchLine.Init();
                PurchLine."Document Type" := PurchLine."Document Type"::Invoice;
                PurchLine."Document No." := PurchHeader."No.";
                PurchLine."Line No." := LineNo;
                PurchLine.Validate(Type, DocumentCapturingLine.Type);
                PurchLine.Validate("No.", DocumentCapturingLine."No.");
                if DocumentCapturingLine.Description <> '' then
                    PurchLine.Description := CopyStr(DocumentCapturingLine.Description, 1, MaxStrLen(PurchLine.Description));
                if DocumentCapturingLine.Quantity <> 0 then
                    PurchLine.Validate(Quantity, DocumentCapturingLine.Quantity);
                if DocumentCapturingLine."Direct Unit Cost" <> 0 then
                    PurchLine.Validate("Direct Unit Cost", DocumentCapturingLine."Direct Unit Cost");
                if DocumentCapturingLine."Line Discount %" <> 0 then
                    PurchLine.Validate("Line Discount %", DocumentCapturingLine."Line Discount %");
                if DocumentCapturingLine."Gen. Bus. Posting Group" <> '' then
                    PurchLine.Validate("Gen. Bus. Posting Group", DocumentCapturingLine."Gen. Bus. Posting Group");
                if DocumentCapturingLine."VAT Bus. Posting Group" <> '' then
                    PurchLine.Validate("VAT Bus. Posting Group", DocumentCapturingLine."VAT Bus. Posting Group");
                if DocumentCapturingLine."Gen. Prod. Posting Group" <> '' then
                    PurchLine.Validate("Gen. Prod. Posting Group", DocumentCapturingLine."Gen. Prod. Posting Group");
                if DocumentCapturingLine."VAT Prod. Posting Group" <> '' then
                    PurchLine.Validate("VAT Prod. Posting Group", DocumentCapturingLine."VAT Prod. Posting Group");
                case true of
                    DocumentCapturingLine."Shortcut Dimension 1 Code" <> '':
                        PurchLine.Validate("Shortcut Dimension 1 Code", DocumentCapturingLine."Shortcut Dimension 1 Code");
                    DocumentCapturingLine."Shortcut Dimension 2 Code" <> '':
                        PurchLine.Validate("Shortcut Dimension 2 Code", DocumentCapturingLine."Shortcut Dimension 2 Code");
                end;
                PurchLine.Insert(true);
            until DocumentCapturingLine.Next() = 0;


        if ("Shortcut Dimension 1 Code" = '') and ("Shortcut Dimension 2 Code" = '') and (LineDimensionBlank) then begin
            PurchHeader2.Get(PurchHeader."Document Type", PurchHeader."No.");
            PurchHeader2.SetHideValidationDialog(true);
            PurchHeader2.Validate("Shortcut Dimension 1 Code", '');
            PurchHeader2.SetHideValidationDialog(false);
            PurchHeader2.Modify();
        end;
        InsertDocumentAttachment(PurchHeader);
        TransferAdditionalAttachments(PurchHeader);
        Rec.Status := Rec.Status::Processed;
        "Last Status Change Date" := WorkDate();
    end;

    local procedure InsertDocumentAttachment(var
                                                 PurchHeader: Record "Purchase Header")
    var
        DocumentAttachment: Record "Document Attachment";
        DocumentInStream: InStream;
        ID: Integer;
        FileContent: Text;
        Base64CU: Codeunit "Base64 Convert";
        DocumentStream: OutStream;
        TempBlob: Codeunit "Temp Blob";
        FileMgt: Codeunit "File Management";
    begin
        DocumentAttachment.Init();
        DocumentAttachment.ID := 0;
        DocumentAttachment."Table ID" := Database::"Purchase Header";
        DocumentAttachment."Document Type" := DocumentAttachment."Document Type"::Invoice;
        DocumentAttachment."No." := PurchHeader."No.";
        DocumentAttachment."Line No." := 0;
        DocumentAttachment."File Name" := FileMgt.GetFileNameWithoutExtension(Rec."File Name");
        DocumentAttachment."File Extension" := 'PDF';
        DocumentAttachment."File Type" := DocumentAttachment."File Type"::PDF;
        Rec.CalcFields(Attachment);
        if Rec.Attachment.HasValue then begin
            Rec.Attachment.CreateInStream(DocumentInStream);
            DocumentInStream.ReadText(FileContent);
            TempBlob.CreateOutStream(DocumentStream);
            Base64CU.FromBase64(fileContent, DocumentStream);
            TempBlob.CreateInStream(DocumentInStream);
        end else
            exit;
        DocumentAttachment."Document Reference ID".ImportStream(DocumentInStream, '');
        DocumentAttachment.Insert(true);
    end;

    local procedure TransferAdditionalAttachments(var PurchHeader: Record "Purchase Header")
    var
        FromDocumentAttachment, FromDocumentAttachment2, ToDocumentAttachment : Record "Document Attachment";
    begin
        FromDocumentAttachment.Reset();
        FromDocumentAttachment.SetRange("Table ID", Database::"Document Capturing Header");
        if FromDocumentAttachment.IsEmpty() then
            exit;
        FromDocumentAttachment.SetRange("No.", Rec."Document No.");
        if FromDocumentAttachment.FindSet() then
            repeat
                Clear(ToDocumentAttachment);
                ToDocumentAttachment.Init();
                ToDocumentAttachment.TransferFields(FromDocumentAttachment);
                ToDocumentAttachment.Validate("Table ID", Database::"Purchase Header");
                ToDocumentAttachment.Validate("Document Type", ToDocumentAttachment."Document Type"::Invoice);
                ToDocumentAttachment.Validate("No.", PurchHeader."No.");
                if not ToDocumentAttachment.Insert(true) then;

                ToDocumentAttachment."Attached Date" := FromDocumentAttachment."Attached Date";
                ToDocumentAttachment.Modify();
                FromDocumentAttachment2 := FromDocumentAttachment;
                FromDocumentAttachment2.Delete(true);
            until FromDocumentAttachment.Next() = 0;
    end;

    local procedure GetItemNoByDescription(ItemText: Text): Code[20]
    var
        ItemRec: Record Item;
        NoFiltersApplied: Boolean;
        ItemFilterFromStart: Text;
        ItemWithoutQuote: Text;
    begin
        if StrLen(ItemText) <= MaxStrLen(ItemRec."No.") then
            if ItemRec.Get(ItemText) then
                exit(ItemRec."No.");

        ItemRec.SetRange(Blocked, false);
        ItemRec.SetRange(Description, copystr(ItemText, 1, MaxStrLen(ItemRec.Description)));
        if ItemRec.FindFirst() then
            exit(ItemRec."No.");

        ItemWithoutQuote := ConvertStr(ItemText, '''', '?');

        ItemRec.SetFilter(Description, '''@' + ItemWithoutQuote + '''');

        if ItemRec.FindFirst() and (ItemRec.Count() = 1) then
            exit(ItemRec."No.");
        ItemRec.SetRange(Description);

        ItemFilterFromStart := '''@' + ItemWithoutQuote + '*''';

        ItemRec.FilterGroup := -1;
        ItemRec.SetFilter("No.", ItemFilterFromStart);
        ItemRec.SetFilter(Description, ItemFilterFromStart);
        if ItemRec.FindFirst() then
            exit(ItemRec."No.");
    end;

    local procedure GetUOMByDescription(UOMText: Text): Code[20]
    var
        UOMRec: Record "Unit of Measure";
        NoFiltersApplied: Boolean;
        ItemFilterFromStart: Text;
        UOMWithoutQuote: Text;
    begin
        if StrLen(UOMText) <= MaxStrLen(UOMRec.Code) then
            if UOMRec.Get(UOMText) then
                exit(UOMRec.Code);

        UOMRec.SetRange(Description, UOMText);
        if UOMRec.FindFirst() then
            exit(UOMRec.Code);

        UOMWithoutQuote := ConvertStr(UOMText, '''', '?');

        UOMRec.SetFilter(Description, '''@' + UOMWithoutQuote + '''');

        if UOMRec.FindFirst() and (UOMRec.Count() = 1) then
            exit(UOMRec.Code);
        UOMRec.SetRange(Description);

        ItemFilterFromStart := '''@' + UOMWithoutQuote + '*''';

        UOMRec.FilterGroup := -1;
        UOMRec.SetFilter(Code, ItemFilterFromStart);
        UOMRec.SetFilter(Description, ItemFilterFromStart);
        if UOMRec.FindFirst() then
            exit(UOMRec.Code);
    end;

    local procedure GetVendorNoByName(VendorText: Text[100]): Code[20]
    var
        Vendor: Record Vendor;
        NoFiltersApplied: Boolean;
        VendorFilterFromStart: Text;
        VendorWithoutQuote: Text;
    begin
        if StrLen(VendorText) <= MaxStrLen(Vendor."No.") then
            if Vendor.Get(VendorText) then
                exit(Vendor."No.");

        Vendor.SetRange(Blocked, Vendor.Blocked::" ");
        Vendor.SetRange(Name, VendorText);
        if Vendor.FindFirst() and (Vendor.Count() = 1) then
            exit(Vendor."No.");

        VendorWithoutQuote := ConvertStr(VendorText, '''', '?');

        Vendor.SetFilter(Name, '''@' + VendorWithoutQuote + '''');

        if Vendor.FindSet() and (Vendor.Count() = 1) then
            exit(Vendor."No.");
        Vendor.SetRange(Name);

        VendorFilterFromStart := '''@' + VendorWithoutQuote + '*''';

        Vendor.FilterGroup := -1;
        Vendor.SetFilter("No.", VendorFilterFromStart);
        Vendor.SetFilter(Name, VendorFilterFromStart);
        if Vendor.FindSet() and (Vendor.Count() = 1) then
            exit(Vendor."No.");
    end;

    [TryFunction]
    local procedure HasValidValue(Value: Variant)
    var
        B: Boolean;
        D: Date;
        Dec: Decimal;
        Int: Integer;
        T: Time;
    begin
        case true of
            Value.IsInteger:
                Int := Value;
            Value.IsDecimal:
                Dec := Value;
            Value.IsDate:
                D := Value;
            Value.IsTime:
                T := Value;
        end;
    end;

    local procedure ShowResultMessage(var ErrorMessage: Record "Error Message")
    var
        DocCreatedMsg: Label 'Purchase invoice %1 has been created.', Comment = '%1 can be Purchase Invoice, %2 is an ID (e.g. 1001)';
        DocCreatedWarningsMsg: Label 'Purchase invoice %1 has been created with warnings.', Comment = '%1 can be Purchase Invoice, %2 is an ID (e.g. 1001)';
    begin
        ErrorMessage.Reset();
        ErrorMessage.SetRange("Context Record ID", Rec.RecordId);
        ErrorMessage.CopyToTemp(TempErrorMessage);
        if TempErrorMessage.ErrorMessageCount(ErrorMessage."Message Type"::Warning) > 0 then
            Message(DocCreatedWarningsMsg, "ERP Document No.")
        else
            Message(DocCreatedMsg, "ERP Document No.");
    end;

    procedure GetVendorDetails()
    var
        VendorRec: Record Vendor;
        VendorNo: Code[20];
        VendorMissLbl: Label 'Vendor master cannot be found with vendor name, address and VAT registration no.';
    begin
        ClearErrorMessages();
        ErrorMessage.SetContext(Rec);
        if Rec."VAT Registration No." <> '' then
            VendorNo := GetVendorNoByVATRegNo(DelChr(Rec."VAT Registration No.", '=', ' ,./\|{]}'));
        if VendorNo = '' then
            VendorNo := GetVendorNoByNameAddr(CopyStr(Rec."Vendor Name", 1, 100), CopyStr(Rec."Vendor Address", 1, 100), DelChr(Rec."VAT Registration No.", '=', ' ,./\|{]}'));
        if VendorRec.Get(VendorNo) then
            Rec."Buy-from Vendor No." := VendorNo
        else begin
            ErrorMessage.LogSimpleMessage(ErrorMessage."Message Type"::Error, VendorMissLbl);
            Error(VendorMissLbl);
        end;
        Commit();
    end;

    local procedure GetVendorNoByVATRegNo(VATRegNo: Text): Code[20]
    var
        VendorLRec: Record Vendor;
    begin
        VendorLRec.Reset();
        VendorLRec.SetRange("VAT Registration No.", VATRegNo);
        if VendorLRec.FindSet() then
            if VendorLRec.Count = 1 then
                exit(VendorLRec."No.")
            else
                exit(GetVendorNoByNameAddrVAT(CopyStr(Rec."Vendor Name", 1, 100), CopyStr(Rec."Vendor Address", 1, 100), VATRegNo))
        else
            exit('');
    end;

    procedure GetVendorNoByNameAddrVAT(VendorText: Text[100]; VendorAddr: Text[100]; VATRegNo: Text) "No.": Code[20]
    var
        Vendor: Record Vendor;
        NoFiltersApplied: Boolean;
        VendorWithoutQuote: Text;
        VendorAddrWithoutQuote: Text;
        VendorNameStarting: Text[100];
        Pos: Integer;
        VendorAddrStarting: Text[100];
        VendorUpdateConfirm: Label 'Please confirm to update the VAT Registration No. %1 to vendor %2 master data.?';
        EventSubs: Codeunit "Event Subscribers";
        VendorFilter: Record Vendor;
    begin
        VendorWithoutQuote := ConvertStr(VendorText, '''', '?');
        Pos := StrPos(VendorWithoutQuote, ' ');
        VendorNameStarting := CopyStr(VendorWithoutQuote, 1, Pos);

        VendorAddrWithoutQuote := ConvertStr(VendorAddr, '''', '?');
        Pos := StrPos(VendorAddrWithoutQuote, ' ');
        VendorAddrStarting := CopyStr(VendorAddrWithoutQuote, 1, Pos);

        Vendor.SetFilter(Name, '@*' + VendorNameStarting + '*');
        Vendor.SetFilter(Address, '@*' + VendorAddrStarting + '*');
        Vendor.SetRange("VAT Registration No.", VATRegNo);
        if Vendor.FindSet() then
            if Vendor.Count() = 1 then
                "No." := Vendor."No."
            else begin
                if GuiAllowed then begin
                    Commit();
                    if PAGE.RunModal(0, Vendor) = ACTION::LookupOK then
                        "No." := Vendor."No."
                    else
                        "No." := '';
                end else
                    SendToVerified := true;
            end
        else
            "No." := '';
        if (Vendor.Get("No.")) and (Vendor."VAT Registration No." = '') then
            if GuiAllowed then
                if Confirm(VendorUpdateConfirm, true, VATRegNo, Vendor.Name) then begin
                    Vendor."VAT Registration No." := VATRegNo;
                    Vendor.Modify(true);
                end;
    end;

    procedure GetVendorNoByNameAddr(VendorText: Text[100]; VendorAddr: Text[100]; VATRegNo: Text) "No.": Code[20]
    var
        Vendor: Record Vendor;
        NoFiltersApplied: Boolean;
        VendorWithoutQuote: Text;
        VendorAddrWithoutQuote: Text;
        VendorNameStarting: Text[100];
        Pos: Integer;
        VendorAddrStarting: Text[100];
        VendorUpdateConfirm: Label 'Please confirm to update the VAT Registration No. %1 to vendor %2 master data.?';
    begin
        VendorWithoutQuote := ConvertStr(VendorText, '''', '?');
        Pos := StrPos(VendorWithoutQuote, ' ');
        VendorNameStarting := CopyStr(VendorWithoutQuote, 1, Pos);

        VendorAddrWithoutQuote := ConvertStr(VendorAddr, '''', '?');
        Pos := StrPos(VendorAddrWithoutQuote, ' ');
        VendorAddrStarting := CopyStr(VendorAddrWithoutQuote, 1, Pos);

        Vendor.SetFilter(Name, '@*' + VendorNameStarting + '*');
        Vendor.SetFilter(Address, '@*' + VendorAddrStarting + '*');
        if Vendor.FindSet() then
            if Vendor.Count() = 1 then
                "No." := Vendor."No."
            else begin
                if GuiAllowed then begin
                    Commit();
                    if Page.RunModal(0, Vendor) = Action::LookupOK then
                        "No." := Vendor."No.";
                end else
                    SendToVerified := true;
            end
        else
            "No." := '';
        if (Vendor.Get("No.")) and
            (Vendor."VAT Registration No." = '') and
            (VATRegNo <> '')
         then
            if GuiAllowed then
                if Confirm(VendorUpdateConfirm, true, VATRegNo, Vendor.Name) then begin
                    Vendor."VAT Registration No." := VATRegNo;
                    Vendor.Modify(true);
                end;
    end;
}
