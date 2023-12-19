reportextension 50014 SaleOrderConfirmation extends "Standard Sales - Order Conf."
{
    dataset
    {
        add(Header)
        {
            column(ShipToaddCap; ShipToaddCap)
            { }
            column(PaymentTermsCap; PaymentTermsCap)
            { }
            column(OrderdateCap; OrderdateCap)
            { }
            column(QuoteNoCap; QuoteNoCap)
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
            column(ArticleDesCap; ArticleDesCap)
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
            column(PostingDateCap; PostingDateCap)
            { }
            column(Posting_Date; "Posting Date")
            { }
            column(Due_Date; "Due Date")
            { }
            column(Order_Date; "Order Date")
            { }
            column(Shipment_Method_Code; "Shipment Method Code")
            { }
            column(SalesConfirmationLbl; SalesConfirmationLbl)
            { }
            column(UnitCap; UnitCap)
            { }
            column(QtyCap; QtyCap)
            { }
            column(DescriptionCap; DescriptionCap)
            { }
            column(NoCap; NoCap)
            { }

        }
        add(line)
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

                column(Entry_No_; TempTrackingSpecBuffer."Entry No.") { }
                column(TempTrackingSpecBuffer_ExpirationDate; TempTrackingSpecBuffer."Expiration Date") { }
                column(TempTrackingSpecBuffer_SerialNo; TempTrackingSpecBuffer."Serial No.") { }

                trigger OnAfterGetRecord()
                begin
                    if Number = 1 then
                        OK := TempTrackingSpecBuffer.Find('-')
                    else
                        OK := TempTrackingSpecBuffer.Next <> 0;
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
                FormatAddr: Codeunit "Format Address";
                RespCenter: Record "Responsibility Center";
                CompanyInfo: Record "Company Information";
                Currency: Record Currency;
                PaymentTerms: Record "Payment Terms";
                GeneralLedgerSetup: Record "General Ledger Setup";
            begin
                CompanyInfo.Get();
                FormatAddr.GetCompanyAddr("Responsibility Center", RespCenter, CompanyInfo, CompanyAddress);
                for i := 1 to ArrayLen(CompanyAddress) do begin
                    if (CompanyAdd = '') and (CompanyAddress[i] <> '') then
                        CompanyAdd := CompanyAddress[i]
                    else
                        if CompanyAddress[i] <> '' then
                            CompanyAdd := CompanyAdd + ' | ' + CompanyAddress[i];
                end;
                if Currency.Get("Currency Code") then
                    CurrSymbol := Currency.GetCurrencySymbol()
                else
                    if GeneralLedgerSetup.Get() then begin
                        CurrCode := GeneralLedgerSetup."LCY Code";
                        CurrSymbol := GeneralLedgerSetup.GetCurrencySymbol();
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
        modify(line)
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
                TempTrackingSpecBuffer.DeleteAll();
                If ItemLRec.Get("No.") then begin
                    if ItemLRec."Item Tracking Code" <> '' then
                        ItemTrackingDoc.FindReservEntries(TempTrackingSpecBuffer, Database::"Sales Line", 1, "Document No.", '', 0, "Line No.", '');
                end;

            end;
        }
    }




    rendering
    {
        layout(LayoutName)
        {
            Type = RDLC;
            LayoutFile = 'Report Ext\Layouts\Sales Order Confirmation.rdl';
        }
    }
    var
        TempTrackingSpecBuffer: Record "Tracking Specification" temporary;
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
        QuoteNoCap: Label 'Quote Number';
        TermsofdeliveryCap: Label 'Delivery Condition';
        CustomerNoCap: Label 'Customer Number';
        YourReferenceCap: Label 'Your Reference';
        OrderdateCap: Label 'Order Date';
        DuedateCap: Label 'Due date';
        ArticleDesCap: Label 'Description';
        UnitPriceCap: Label 'Unit Price';
        AmountCap: Label 'Amount';
        TotalExclVatCap: Label 'Total excl.VAT';
        VatAmountCap: Label 'VAT Amount';
        TotalInclVatCap: Label 'Total incl.VAT';
        SerialNoCap: Label 'Serial No.';
        CurrecySymbol1: Text[10];
        DescriptionVar: Text[100];
        ShowEngImage: Boolean;
        ShowDEImage: Boolean;
        ShipmentDatecap: Label 'Shipment Date';
        languageCodevar: Record Language;
        PostingDateCap: Label 'Posting Date';
        NoCap: Label 'No.';
        DescriptionCap: Label 'Description';
        QtyCap: Label 'Qty';
        UnitCap: Label 'Unit';
        SalesConfirmation1Lbl: Label 'Order Confirmation';
        UnitOfMeasure: text[100];
}