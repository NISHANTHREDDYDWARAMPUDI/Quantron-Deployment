reportextension 50013 PurchaseReciept extends "Purchase - Receipt"
{
    dataset
    {
        add("Purch. Rcpt. Header")
        {
            column(CompanyAdd; CompanyAdd)
            { }
            column(ShowEngImage; ShowEngImage)
            { }
            column(ShowDEImage; ShowDEImage)
            { }
            column(DescriptionVar; DescriptionVar)
            { }
            column(CompanyPicture; CompanyInfo1.Picture)
            { }
            column(ShipToaddCap; ShipToaddCap)
            { }
            column(Page_Lbl; Page_Lbl)
            { }
            column(Shiptoaddress1; Shiptoaddress[1])
            { }
            column(Shiptoaddress2; Shiptoaddress[2])
            { }
            column(Shiptoaddress3; Shiptoaddress[3])
            { }
            column(Shiptoaddress4; Shiptoaddress[4])
            { }
            column(Shiptoaddress5; Shiptoaddress[5])
            { }
            column(Shiptoaddress6; Shiptoaddress[6])
            { }
            column(Shiptoaddress7; Shiptoaddress[7])
            { }
            column(Shiptoaddress8; Shiptoaddress[8])
            { }

            column(UnitCap; UnitCap)
            { }
            column(QtyCap; QtyCap)
            { }
            column(DescriptionCap; DescriptionCap)
            { }
            column(NoCap; NoCap)
            { }
            column(VendorNoCap; VendorNoCap)
            { }
            column(DocumentDateCap; DocumentDateCap)
            { }
            column(OrderNoCap; OrderNoCap)
            { }
            column(PostingDateCap; PostingDateCap)
            { }
            Column(CurrSymbol; CurrSymbol)
            { }
            column(DueDateCap; DueDateCap)
            { }
            column(PaymentTermCap; PaymentTermCap)
            { }
            column(DeliveryConditionCap; DeliveryConditionCap)
            { }
            column(Order_No_; "Order No.")
            { }
            column(Shipment_Method_Code; "Shipment Method Code")
            { }
            column(SerialNoCap; SerialNoCap)
            { }
            column(Document_Date; "Document Date")
            { }
            column(Posting_Date; "Posting Date")
            { }
            column(Due_Date; "Due Date")
            { }
            column(Pay_to_Vendor_No_; "Pay-to Vendor No.")
            { }
            column(VendorAddress1; VendorAddress[1])
            { }
            column(VendorAddress2; VendorAddress[2])
            { }
            column(VendorAddress3; VendorAddress[3])
            { }
            column(VendorAddress4; VendorAddress[4])
            { }
            column(VendorAddress5; VendorAddress[5])
            { }
            column(VendorAddress6; VendorAddress[6])
            { }
            column(VendorAddress7; VendorAddress[7])
            { }
            column(VendorAddress8; VendorAddress[8])
            { }
        }
        add("Purch. Rcpt. Line")
        {
            column(UnitOfMeasure; UnitOfMeasure)
            { }
            column(FormattedQty; Format(Quantity))
            { }
        }
        add(CopyLoop)
        {
            column(DocumentCaption1; StrSubstNo(PurchasereceiptCap, CopyText1))
            { }
            column(OutputNo1; OutputNo1)
            { }
        }
        addafter(DimensionLoop2)
        {
            dataitem(Integer; Integer)
            {
                DataItemTableView = SORTING(Number) WHERE(Number = FILTER(1 ..));

                column(Quantity; TempItemLedEntry.Quantity)
                { }
                column(Entry_No_; TempItemLedEntry."Entry No.")
                { }
                column(TempItemLedEntry_ExpirationDate; TempItemLedEntry."Expiration Date")
                { }
                column(TempItemLedEntry_SerialNo; TempItemLedEntry."Serial No.")
                { }

                trigger OnAfterGetRecord()
                begin
                    if Number = 1 then
                        OK := TempItemLedEntry.Find('-')
                    else
                        OK := TempItemLedEntry.Next <> 0;
                    if not OK then
                        CurrReport.Break();
                end;
            }
        }
        modify("Purch. Rcpt. Header")
        {
            trigger OnAfterAfterGetRecord()
            var
                i: Integer;
                FormatAddr: Codeunit "Format Address";
                RespCenter: Record "Responsibility Center";
                Currency: Record Currency;
                PaymentTerms: Record "Payment Terms";
                GeneralLedgerSetup: Record "General Ledger Setup";
            begin
                clear(DescriptionVar);
                clear(ShowEngImage);
                clear(ShowDEImage);
                CompanyInfo1.Get();
                CompanyInfo1.CalcFields(Picture);
                FormatAddr.GetCompanyAddr("Responsibility Center", RespCenter, CompanyInfo1, CompanyAddress);
                for i := 1 to ArrayLen(CompanyAddress) do begin
                    if (CompanyAdd = '') and (CompanyAddress[i] <> '') then
                        CompanyAdd := CompanyAddress[i]
                    else
                        if CompanyAddress[i] <> '' then
                            CompanyAdd := CompanyAdd + ' | ' + CompanyAddress[i];
                end;
                FormatAddr.PurchRcptShipTo(Shiptoaddress, "Purch. Rcpt. Header");
                FormatAddr.PurchRcptPayTo(VendorAddress, "Purch. Rcpt. Header");
                if PaymentTerms.Get("Payment Terms Code") then begin
                    if "Purch. Rcpt. Header"."Language Code" <> '' then
                        if languageCodevar.Get("Purch. Rcpt. Header"."Language Code") then begin
                            if (languageCodevar."Windows Language ID" = 1033) or (languageCodevar."Windows Language ID" = 2057) then begin
                                DescriptionVar := PaymentTerms."English Description";
                                ShowEngImage := true;
                                ShowDEImage := false;
                            end else begin
                                DescriptionVar := PaymentTerms.Description;
                                ShowEngImage := false;
                                ShowDEImage := true;
                            end;
                        end else begin
                            DescriptionVar := PaymentTerms.Description;
                            ShowEngImage := false;
                            ShowDEImage := true;
                        end
                    else begin
                        languageCodevar.Reset();
                        languageCodevar.SetRange("Windows Language ID", GlobalLanguage);
                        if languageCodevar.FindFirst() then
                            if (languageCodevar."Windows Language ID" = 1033) or (languageCodevar."Windows Language ID" = 2057) then begin
                                DescriptionVar := PaymentTerms."English Description";
                                ShowEngImage := true;
                                ShowDEImage := false;
                            end
                            else begin
                                DescriptionVar := PaymentTerms.Description;
                                ShowEngImage := false;
                                ShowDEImage := true;
                            end;
                    end;
                end;
            end;
        }
        modify("Purch. Rcpt. Line")
        {
            trigger OnAfterAfterGetRecord()
            var
                UnitOfMeasureRec: Record "Unit of Measure";
                UnitOfMeasureTranslation: Record "Unit of Measure Translation";
                ItemTrackingDoc: Codeunit "Item Tracking Doc. Management";
            begin
                if "Unit of Measure Code" = '' then
                    UnitOfMeasure := ''
                else begin
                    if not UnitOfMeasureRec.Get("Unit of Measure Code") then
                        UnitOfMeasureRec.Init();
                    UnitOfMeasure := UnitOfMeasureRec.Description;
                    if "Purch. Rcpt. Header"."Language Code" <> '' then begin
                        UnitOfMeasureTranslation.SetRange(Code, "Unit of Measure Code");
                        UnitOfMeasureTranslation.SetRange("Language Code", "Purch. Rcpt. Header"."Language Code");
                        if UnitOfMeasureTranslation.FindFirst() then
                            UnitOfMeasure := UnitOfMeasureTranslation.Description;
                    end else begin
                        languageCodevar.Reset();
                        languageCodevar.SetRange("Windows Language ID", GlobalLanguage);
                        if not languageCodevar.FindFirst() then
                            languageCodevar.Init();
                        UnitOfMeasureTranslation.SetRange(Code, "Unit of Measure Code");
                        UnitOfMeasureTranslation.SetRange("Language Code", languageCodevar.Code);
                        if UnitOfMeasureTranslation.FindFirst() then
                            UnitOfMeasure := UnitOfMeasureTranslation.Description;
                    end;
                end;
                TempItemLedEntry.DeleteAll();
                ItemTrackingDoc.RetrieveEntriesFromShptRcpt(TempItemLedEntry, DATABASE::"Purch. Rcpt. Line", 0, "Document No.", '', 0, "Line No.");
            end;
        }
        modify(CopyLoop)
        {
            trigger OnAfterAfterGetRecord()
            var
                myInt: Integer;
            begin
                if Number > 1 then begin
                    CopyText1 := FormatDocument1.GetCOPYText();
                    OutputNo1 += 1;
                end;
            end;

            trigger OnBeforePreDataItem()
            var
                myInt: Integer;
            begin
                OutputNo1 := 1;

                NoOfLoops1 := Abs(NoOfCopies1) + 1;
                CopyText1 := '';
                SetRange(Number, 1, NoOfLoops1);
            end;
        }
    }

    requestpage
    {
        // Add changes to the requestpage here
    }

    rendering
    {
        layout(LayoutName)
        {
            Type = RDLC;
            LayoutFile = 'Report Ext\Layouts\Purchase Reciept.rdl';
        }
    }
    var
        TempItemLedEntry: Record "Item Ledger Entry" temporary;
        OK: Boolean;
        NoOfCopies1: Integer;
        NoOfLoops1: Integer;
        FormatDocument1: Codeunit "Format Document";
        CompanyAddress: array[8] of Text[100];
        Shiptoaddress: array[8] of Text[100];
        VendorAddress: array[8] of Text[100];
        CompanyAdd: Text[500];
        FormattedQty: text[50];
        OutputNo1: Integer;
        FormattedUnitCost: text[50];
        FormattedAmount: text[50];
        Formatdiscount: text[50];
        DescriptionVar: Text[100];
        UnitOfMeasure: text[50];
        ShowEngImage: Boolean;
        CurrSymbol: text[10];
        CurrCode: code[10];
        CopyText1: Text[30];
        ShowDEImage: Boolean;
        languageCodevar: Record Language;
        CompanyInfo1: Record "Company Information";

        ShipToaddCap: Label 'Delivery Address';
        Page_Lbl: label 'Page';
        DocumentDateCap: Label 'Document Date';
        OrderNoCap: Label 'Order No.';
        PostingDateCap: Label 'Issue Date';
        DueDateCap: Label 'Due Date';
        PaymentTermCap: Label 'Payment Term';
        DeliveryConditionCap: Label 'Delivery Condition';
        VendorNoCap: Label 'Supplier No.';

        NoCap: Label 'No.';
        DescriptionCap: Label 'Description';
        QtyCap: Label 'Qty';
        UnitCap: Label 'Unit';

        SerialNoCap: Label 'Serial No.';
        PurchasereceiptCap: Label 'Purchase - Receipt %1', Comment = '%1 = Document No.';
}