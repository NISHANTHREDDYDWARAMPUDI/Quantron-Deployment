reportextension 50015 SalesCreditMemo extends "Standard Sales - Credit Memo"
{
    dataset
    {
        add(Header)
        {
            column(ShipToaddCap; ShipToaddCap)
            { }
            column(PaymentTermsCap; PaymentTermsCap)
            { }
            column(DocumentDateCap; DocumentDateCap)
            { }
            column(TermsofdeliveryCap; TermsofdeliveryCap)
            { }
            column(CustomerNoCap; CustomerNoCap)
            { }
            column(YourReferenceCap; YourReferenceCap)
            { }
            column(DuedateCap; DuedateCap)
            { }
            column(Payment_Terms_Code; "Payment Terms Code")
            { }
            column(UnitPriceCap; UnitPriceCap)
            { }
            column(AmountCap; AmountCap)
            { }
            column(CompanyAdd; CompanyAdd)
            { }
            column(TotalExclVatCap; TotalExclVatCap)
            { }
            column(VatAmountCap; VatAmountCap)
            { }
            column(TotalInclVatCap; TotalInclVatCap)
            { }
            column(SerialNoCap; SerialNoCap)
            { }
            column(DescriptionVar; DescriptionVar)
            { }
            column(ShowEngImage; ShowEngImage)
            { }
            column(ShowDEImage; ShowDEImage)
            { }
            column(ShipmentDatecap; ShipmentDatecap)
            { }
            column(Shipment_Date1; "Shipment Date")
            { }
            column(Due_Date; "Due Date")
            { }
            column(Document_Date; "Document Date")
            { }
            column(Shipment_Method_Code; "Shipment Method Code")
            { }
            column(UnitCap; UnitCap)
            { }
            column(QtyCap; QtyCap)
            { }
            column(DescriptionCap; DescriptionCap)
            { }
            column(NoCap; NoCap)
            { }
            column(SalespersonCap; SalespersonCap)
            { }
            column(Your_Reference; "Your Reference")
            { }
            column(CurrencySymbol1; CurrSymbol1)
            { }
            column(SalesCreditMemoCap; SalesCreditMemoCap)
            { }

        }
        add(Line)
        {
            column(UnitOfMeasure1; UnitOfMeasure)
            { }
            column(VAT__; "VAT %")
            { }
        }
        addlast(Line)
        {
            dataitem(Integer; Integer)
            {
                DataItemTableView = SORTING(Number) WHERE(Number = FILTER(1 ..));

                column(Entry_No_; TempItemLedEntry."Entry No.")
                { }
                column(TempTrackingSpecBuffer_ExpirationDate; TempItemLedEntry."Expiration Date")
                { }
                column(TempTrackingSpecBuffer_SerialNo; TempItemLedEntry."Serial No.")
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
        modify(Header)
        {
            trigger OnAfterAfterGetRecord()

            var
                i: Integer;
                FormatAddr1: Codeunit "Format Address";
                RespCenter1: Record "Responsibility Center";
                CompanyInfo1: Record "Company Information";
                Currency: Record Currency;
                PaymentTerms1: Record "Payment Terms";
                GeneralLedgerSetup: Record "General Ledger Setup";
            begin
                CompanyInfo1.Get();
                FormatAddr1.GetCompanyAddr("Responsibility Center", RespCenter1, CompanyInfo1, CompanyAddress);
                for i := 1 to ArrayLen(CompanyAddress) do begin
                    if (CompanyAdd = '') and (CompanyAddress[i] <> '') then
                        CompanyAdd := CompanyAddress[i]
                    else
                        if CompanyAddress[i] <> '' then
                            CompanyAdd := CompanyAdd + ' | ' + CompanyAddress[i];
                end;
                if Currency.Get("Currency Code") then
                    CurrSymbol1 := Currency.GetCurrencySymbol()
                else
                    if GeneralLedgerSetup.Get() then begin
                        CurrCode1 := GeneralLedgerSetup."LCY Code";
                        CurrSymbol1 := GeneralLedgerSetup.GetCurrencySymbol();
                    end;
                if PaymentTerms.Get("Payment Terms Code") then begin
                    if Header."Language Code" <> '' then
                        if languageCodevar.Get(Header."Language Code") then begin
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
        modify(Line)
        {
            trigger OnAfterAfterGetRecord()
            var
                UnitOfMeasureRec: Record "Unit of Measure";
                UnitOfMeasureTranslation: Record "Unit of Measure Translation";
                ItemTrackingDoc: Codeunit "Item Tracking Doc. Management";
                ItemLRec: Record Item;
            begin
                if "Unit of Measure Code" = '' then
                    UnitOfMeasure := ''
                else begin
                    if not UnitOfMeasureRec.Get("Unit of Measure Code") then
                        UnitOfMeasureRec.Init();
                    UnitOfMeasure := UnitOfMeasureRec.Description;
                    if Header."Language Code" <> '' then begin
                        UnitOfMeasureTranslation.SetRange(Code, "Unit of Measure Code");
                        UnitOfMeasureTranslation.SetRange("Language Code", Header."Language Code");
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
                ItemTrackingDoc.RetrieveEntriesFromPostedInvoice(TempItemLedEntry, Line.RowID1());

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
            LayoutFile = 'Report Ext\Layouts\Sales Credit Memo.rdl';
            Caption = 'Sales Credit Memo B2B';
        }
    }
    var
        TempItemLedEntry: Record "Item Ledger Entry" temporary;
        OK: Boolean;
        DocumentCaption: Text[100];
        DownPaymtText: Text[250];
        TotalAmtText: Text[150];
        CountryName: Code[100];
        CompanyAddress: array[8] of Text[100];
        CompanyAdd: Text[500];
        Footertext: Text[250];
        ShipToaddCap: Label 'Delivery Address';
        PaymentTermsCap: Label 'Payment Term';
        TermsofdeliveryCap: Label 'Delivery Condition';
        CustomerNoCap: Label 'Customer Number';
        YourReferenceCap: Label 'Your Reference';
        SalespersonCap: label 'Sales Person';
        DuedateCap: Label 'Due date';
        ArticleDesCap: Label 'Description';
        UnitPriceCap: Label 'Unit Price';
        AmountCap: Label 'Amount';
        TotalExclVatCap: Label 'Total excl.VAT';
        VatAmountCap: Label 'VAT Amount';
        TotalInclVatCap: Label 'Total incl.VAT';
        SerialNoCap: Label 'Serial No.';
        CurrSymbol1: Text[10];
        CurrCode1: Text[10];
        DescriptionVar: Text[100];
        ShowEngImage: Boolean;
        ShowDEImage: Boolean;
        ShipmentDatecap: Label 'Shipment Date';
        languageCodevar: Record Language;
        DocumentDateCap: Label 'Document Date';
        NoCap: Label 'No.';
        DescriptionCap: Label 'Description';
        SalesCreditMemoCap: Label 'Sales Credit Memo';
        QtyCap: Label 'Qty';
        UnitCap: Label 'Unit';
        UnitOfMeasure: text[100];
}