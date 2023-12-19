reportextension 50011 PurchaseInvoice extends "Purchase - Invoice"
{

    dataset
    {
        add("Purch. Inv. Header")
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
            column(PurchaseInvoiceNoCap; StrSubstNo(PurchaseInvoiceNoCap, CopyText1))
            { }
            column(VATAmountCap; VATAmountCap)
            { }
            column(TotalInclVATCap; TotalInclVATCap)
            { }
            column(TotalExclVatCap; TotalExclVatCap)
            { }
            column(AmountCap; AmountCap)
            { }
            column(DiscountCap; DiscountCap)
            { }
            column(UnitCostCap; UnitCostCap)
            { }
            column(UnitCap; UnitCap)
            { }
            column(QtyCap; QtyCap)
            { }
            column(DescriptionCap; DescriptionCap)
            { }
            column(NoCap; NoCap)
            { }
            column(VendorInvoiceNoCap; VendorInvoiceNoCap)
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
            column(Vendor_Invoice_No_; "Vendor Invoice No.")
            { }
            column(Shipment_Method_Code; "Shipment Method Code")
            { }
            column(SerialNoCap; SerialNoCap)
            { }
            column(Document_Date; "Document Date")
            { }
            column(VATpercentage; VATpercentage)
            { }
        }
        add(PageLoop)
        {
            column(PostingDate; "Purch. Inv. Header"."Posting Date")
            { }
            column(DueDate; "Purch. Inv. Header"."Due Date")
            { }
        }
        add("Purch. Inv. Line")
        {
            column(FormattedQty; FormattedQty)
            { }
            column(FormattedUnitCost; FormattedUnitCost)
            { }
            column(Formatdiscount; Formatdiscount)
            { }
            column(FormattedAmount; FormattedAmount)
            { }
            column(UnitOfMeasure; UnitOfMeasure)
            { }
            column(VATpercentage1; "VAT %")
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
        modify("Purch. Inv. Header")
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
                clear(CompanyAdd);
                if Currency.Get("Currency Code") then
                    CurrSymbol := Currency.GetCurrencySymbol()
                else
                    if GeneralLedgerSetup.Get() then begin
                        CurrCode := GeneralLedgerSetup."LCY Code";
                        CurrSymbol := GeneralLedgerSetup.GetCurrencySymbol();
                    end;
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
                FormatAddr.PurchInvShipTo(Shiptoaddress, "Purch. Inv. Header");
                if PaymentTerms.Get("Payment Terms Code") then begin
                    if "Purch. Inv. Header"."Language Code" <> '' then
                        if languageCodevar.Get("Purch. Inv. Header"."Language Code") then begin
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
        modify("Purch. Inv. Line")
        {
            trigger OnAfterAfterGetRecord()
            var
                UnitOfMeasureRec: Record "Unit of Measure";
                UnitOfMeasureTranslation: Record "Unit of Measure Translation";
                ItemTrackingDoc: Codeunit "Item Tracking Doc. Management";
            begin
                if Quantity <> 0 then
                    FormattedQty := Format(Quantity)
                else
                    FormattedQty := '';
                if "Direct Unit Cost" <> 0 then
                    FormattedUnitCost := Format("Direct Unit Cost") + CurrSymbol
                else
                    FormattedUnitCost := '';
                if "Line Discount %" <> 0 then
                    Formatdiscount := Format("Line Discount %")
                else
                    Formatdiscount := '';
                if "Line Amount" <> 0 then
                    FormattedAmount := Format("Line Amount") + CurrSymbol
                else
                    FormattedAmount := '';
                if "Unit of Measure Code" = '' then
                    UnitOfMeasure := ''
                else begin
                    if not UnitOfMeasureRec.Get("Unit of Measure Code") then
                        UnitOfMeasureRec.Init();
                    UnitOfMeasure := UnitOfMeasureRec.Description;
                    if "Purch. Inv. Header"."Language Code" <> '' then begin
                        UnitOfMeasureTranslation.SetRange(Code, "Unit of Measure Code");
                        UnitOfMeasureTranslation.SetRange("Language Code", "Purch. Inv. Header"."Language Code");
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
                ItemTrackingDoc.RetrieveEntriesFromPostedInvoice(TempItemLedEntry, "Purch. Inv. Line".RowID1());

            end;
        }
        modify(CopyLoop)
        {
            trigger OnAfterAfterGetRecord()
            var
                FormatDocument: Codeunit "Format Document";
            begin
                if Number > 1 then
                    CopyText1 := FormatDocument.GetCOPYText;
            end;

            trigger OnAfterPreDataItem()
            begin
                CopyText1 := '';
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
            LayoutFile = 'Report Ext\Layouts\Purchase Invoice.rdl';
        }
    }
    var
        TempItemLedEntry: Record "Item Ledger Entry" temporary;
        OK: Boolean;
        CompanyAddress: array[8] of Text[100];
        Shiptoaddress: array[8] of Text[100];
        CompanyAdd: Text[500];
        FormattedQty: text[50];
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
        VendorInvoiceNoCap: Label 'Supplier Invoice No.';
        NoCap: Label 'No.';
        DescriptionCap: Label 'Description';
        QtyCap: Label 'Qty';
        UnitCap: Label 'Unit';
        UnitCostCap: Label 'Unit Price (LCY)';
        DiscountCap: Label 'Discount [%]';
        AmountCap: Label 'Amount';
        TotalExclVatCap: Label 'Total excl.VAT';
        TotalInclVATCap: Label 'Total Incl.VAT';
        VATAmountCap: Label 'VAT Amount';
        PurchaseInvoiceNoCap: Label 'Purchase - Invoice %1';
        SerialNoCap: Label 'Serial No.';
        VATpercentage: Text[10];
}